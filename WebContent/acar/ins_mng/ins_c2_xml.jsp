<?xml version="1.0" encoding="euc-kr"?>
<%@ page contentType="text/xml; charset=euc-kr" %>
<%@ page import="java.util.*,java.text.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.insur.*, acar.cont.*"%> 
<%@ include file="/acar/cookies.jsp" %> 
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>

<rows>	

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String dt = request.getParameter("dt")==null?"":request.getParameter("dt");		
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	if(!st_dt.equals("")) st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) end_dt = AddUtil.replace(end_dt, "-", "");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsComDatabase ic_db = InsComDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();

	
	Vector jarr = ai_db.getInsChangeList3(dt,st_dt,end_dt,gubun1,gubun2,t_wd);
	
	int jarr_size = 0;
	
	jarr_size = jarr.size();
	
	String nn= "";
	String cont_bk = "";
	String ch_item = "";
	String jobjString = "";
	String car_no = "";
	String car_no2 = "";
	int bgcolor_count = 0;
	int bgcolor_count2 = 0;
	int bgcolor_count3 = 0;
	int bgcolor_count4 = 0;
	String reg_dt ="";
	String delete ="";
	String car_mng_id ="";
	int count = 0;
	String firm_nm="";
	String enp_no ="";
	
	 Date d = new Date();
	 Date t = new Date(d.getTime()+(1000*60*60*24*+1));
	 SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	 String sysdate =   sdf.format(d);	
	 String tomorrow =   sdf.format(t);	
		
	if(jarr_size > 0) {
		
		for(int i = 0 ; i < jarr_size ; i++) {
			bgcolor_count =0;
			bgcolor_count2 =0;
			bgcolor_count3 =0;
			bgcolor_count4 =0;
			
			Hashtable ht = (Hashtable)jarr.elementAt(i);
			car_mng_id = String.valueOf(ht.get("CAR_MNG_ID")) == null? "" : String.valueOf(ht.get("CAR_MNG_ID"));
			enp_no = String.valueOf(ht.get("ENP_NO")) == null? "" : String.valueOf(ht.get("ENP_NO"));
			firm_nm = String.valueOf(ht.get("FIRM_NM")) == null? "" : String.valueOf(ht.get("FIRM_NM"));
			
			if(!String.valueOf(ht.get("VALUE01")).equals("�߰� ��ϰ�") && !String.valueOf(ht.get("VALUE01")).equals("��������̰���")){
				//����1 �뿩���� �� ������ ������ ��� ������ ����
				if(String.valueOf(ht.get("VALUE01")).equals("����1 �뿩����") && String.valueOf(ht.get("VALUE06")).equals("������")){
					if(String.valueOf(ht.get("CAR_ST")).equals("3")){ 
						boolean insExCh = ai_db.changeInsExcel(String.valueOf(ht.get("REG_CODE")), String.valueOf(ht.get("SEQ")), "Y");
						//System.out.println("����1 �뿩���� �� ������ ������ ��� ������ ����:"+String.valueOf(ht.get("CAR_NO")));
						continue;
					}
				}
				
				// ����������� ���������뺸�� && ���°� ��� && ����1 �����ϰ� �輭�׸��(value06)�� ������������, ������ ��� ����Ʈ���� �Ⱥ��̰�
				if(!String.valueOf(ht.get("VALUE01")).equals("����������� ���������뺸��")){
					if(!String.valueOf(ht.get("VALUE01")).equals("���°� ���")){
						if( String.valueOf(ht.get("VALUE06")).equals("������������") ||	String.valueOf(ht.get("VALUE06")).equals("������")){
							if(!String.valueOf(ht.get("VALUE01")).contains("����1")){
								boolean insExCh = ai_db.changeInsExcel(String.valueOf(ht.get("REG_CODE")), String.valueOf(ht.get("SEQ")), "Y");
							//	System.out.println("����������� ���������뺸�� && ���°� ��� && ����1 �����ϰ� �輭�׸��(value06)�� ������������, ������ ��� ����Ʈ���� �Ⱥ��̰�:"+String.valueOf(ht.get("CAR_NO")));
								continue;
							}
						}
					}
				}

				// ���������������� BASE���������� ����Ʈ�� 2�� �����°��, �������������� ����Ʈ���� ����
				
				if( String.valueOf(ht.get("VALUE06")).equals("��������������")){
					 int over_cnt =  ic_db.getCheckOverInsExcel(String.valueOf(ht.get("CAR_MNG_ID")));
					if(over_cnt > 1){ 
						boolean insExCh = ai_db.changeInsExcel(String.valueOf(ht.get("REG_CODE")), String.valueOf(ht.get("SEQ")), "Y");
						//System.out.println("��������������:"+String.valueOf(ht.get("CAR_NO")));
						continue;
					}
				}
				
				//����ȭ�� ������ ����Ʈ���� ����
				if(!String.valueOf(ht.get("VALUE01")).equals("����������� ���������뺸��")){
					if(!String.valueOf(ht.get("INS_CON_NO")).contains("P")){
						if(String.valueOf(ht.get("VALUE06")).equals("������")){
							boolean insExCh = ai_db.changeInsExcel(String.valueOf(ht.get("REG_CODE")), String.valueOf(ht.get("SEQ")), "Y");
						//	System.out.println("����ȭ�� ������ ����Ʈ���� ����:"+String.valueOf(ht.get("CAR_NO")));
							continue;
						}
					}
				}
				
				//�縮�� �뿩�����ε� Ź���Ƿ� ����̸鼭 rent_start_dt(�뿩����)�� ���� ��� 
				/* if(String.valueOf(ht.get("VALUE01")).equals("�縮�� �뿩�����ε� Ź���Ƿ� ���") && String.valueOf(ht.get("RENT_START_DT")).equals("") ){
					continue;
				} */
				
		/* 		if(String.valueOf(ht.get("VALUE01")).equals("�縮�� �뿩�����ε� Ź���Ƿ� ���") ){
					//����Ÿ����
					ContEtcBean cont_etc = a_db.getContEtc(String.valueOf(ht.get("RENT_MNG_ID")) ,String.valueOf(ht.get("RENT_L_CD")) );
					//�����ε����ڰ� ���� ��� ����Ʈ�� �ȳ�����
					if(cont_etc.getCar_deli_dt().equals("")){
						continue;
						
					}
				}  */
				
				/*����뿩�������� ���� ��¥���� ���̸� ������ �ʰ� (20190412 ��û��) */
				String fee_rent_start_dt = "";
				int fee_size = af_db.getMaxRentSt(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")));
				for(int j = 0; j < fee_size; j++){
					ContFeeBean ext_fee = a_db.getContFeeNew(String.valueOf(ht.get("RENT_MNG_ID")) , String.valueOf(ht.get("RENT_L_CD")), Integer.toString(j+1));
					if(!ext_fee.getCon_mon().equals("")){
						if(j>0){
							fee_rent_start_dt = ext_fee.getRent_start_dt();
						}
					}
				}
				if(!fee_rent_start_dt.equals("")){
					if(Integer.parseInt(fee_rent_start_dt) > Integer.parseInt(sysdate)){
						//System.out.println("���尳����:"+String.valueOf(ht.get("CAR_NO")));
						continue;
					} 
				}
				
				//�縮�� �뿩�����ε� Ź���Ƿ� ��� �϶��� �����ε��� ����Ȯ��
				/* if(String.valueOf(ht.get("VALUE01")).equals("�縮�� �뿩�����ε� Ź���Ƿ� ���") ) //(20200616 ���� ������� ��� ���� �����ε��� Ȯ���ϵ��� ���� (�������ڿ�û) ) */
					
				/* �����ε����ڰ� ���� ��� ����Ʈ�� �ȳ�����  -�Ʒ���û���� �����*/
				
				/* ��� ���� �����ε����� ������ �����ε������� ����  
				      ������ڷ� ã�� ���� ã�� ��¥ �������� ���� ����Ʈ�� ��������- 2020616 �������ڿ�û */
		       /* �뿩�����ϵ� �߰� 1.�����ε��� 2.�����ε������� 3.�뿩������ 4.�����   */    
		       
				//����Ÿ����
				ContEtcBean cont_etc = a_db.getContEtc(String.valueOf(ht.get("RENT_MNG_ID")) ,String.valueOf(ht.get("RENT_L_CD")) );
				String stand_dt = "";
				if(!cont_etc.getCar_deli_dt().equals("")){
					stand_dt = cont_etc.getCar_deli_dt();
				}else if(!cont_etc.getCar_deli_est_dt().equals("")){
					stand_dt = cont_etc.getCar_deli_est_dt();
				}else if(!fee_rent_start_dt.equals("")){
					stand_dt = fee_rent_start_dt;
				}else{
					stand_dt = String.valueOf(ht.get("RENT_DT"));
				}
				//�������� ���̱�
 			 	/* if(Integer.parseInt(stand_dt) > (Integer.parseInt(tomorrow))){
					//System.out.println(String.valueOf(ht.get("CAR_NO"))+" "+stand_dt);
					continue;
				}    */
 			 	//System.out.println(String.valueOf(ht.get("CAR_NO"))+" "+stand_dt);
 			 	
 			 	SimpleDateFormat sdf2 = new SimpleDateFormat("yyyyMMdd");
	 			Date stand_dt_date =   sdf2.parse(stand_dt);
	 			Date stand_dt_yesterdate = new Date(stand_dt_date.getTime()-(1000*60*60*24*+1));
 			 	String stand_dt_yesterday = sdf2.format(stand_dt_yesterdate);
 			 	
 			 	//������/�ָ��� ��� ������ ó��
 			 	stand_dt_yesterday = ai_db.getValidDt(stand_dt_yesterday).replaceAll("-", "");
 			 	//System.out.println(String.valueOf(ht.get("CAR_NO"))+" "+stand_dt_yesterday);
 			 	if(Integer.parseInt(stand_dt_yesterday) > (Integer.parseInt(sysdate))){
					//System.out.println("�����:"+String.valueOf(ht.get("CAR_NO"))+" ������ : "+stand_dt +", ������(����) : "+stand_dt_yesterday);
					continue;
				}   
				//System.out.println("����:"+String.valueOf(ht.get("CAR_NO"))+" ������ : "+stand_dt +", ������(����) :  "+stand_dt_yesterday);
				
				
				//USE_YN �� null ���� ��� (�°谡 �������̹Ƿ� ���� ���� �Ϸᰡ �ȵȰ�)
				if(String.valueOf(ht.get("USE_YN")).equals("") ){
					//System.out.println("USE_YN �� null ���� ��� :"+String.valueOf(ht.get("CAR_NO")));
					continue;
				}
				
				
				//������ ��� �������� N�̿��� ������ ����û�ÿ��� Y����
		/* 		if(!String.valueOf(ht.get("CLIENT_ST")).equals("1") && !String.valueOf(ht.get("CLIENT_ST")).equals("3")){
					if(cont_etc.getCom_emp_yn().equals("Y")){
						if(cont_etc.getCom_emp_sac_id().equals("")){
							//System.out.println("������ ��� �������� N�̿��� ������ ����û�ÿ��� Y���� :"+String.valueOf(ht.get("CAR_NO")));
							continue;
						}
					}
				} */
				
			}
			
				// �ߺ��Ǵ� ����Ʈ ����
			//	if(	ic_db.getCheckOverInsExcel( String.valueOf(ht.get("CAR_MNG_ID")), String.valueOf(ht.get("VALUE07")),String.valueOf(ht.get("VALUE08"))) > 1 ) continue;
				 
				
				//�ߺ��Ǵ� ���� ������ ����� ǥ��
					
				/* if(!car_mng_id.equals("")){
					int checkCarNo =  ic_db.getCheckOverInsExcelCarNo(car_mng_id);
					if(checkCarNo > 1){//�������� ��ȣ�� 2�� �̻��϶�
						bgcolor_count++;								
					} 
				} */
				
				if(String.valueOf(ht.get("CAR_NO")).equals(car_no2)){
					bgcolor_count++;
					
				}else{
					car_no2=ht.get("CAR_NO")+"";
					bgcolor_count=0;
				}
				
				car_no=ht.get("CAR_NO")+"^javascript:insDisp(&#39;";
				car_no+= ht.get("RENT_MNG_ID")+"&#39;,&#39;"+ht.get("RENT_L_CD")+"&#39;,&#39;"+ht.get("CAR_MNG_ID")+"&#39;,&#39;"+ht.get("INS_ST")+"&#39;)";
				car_no+="^_self";
				
				delete= "<img src='/acar/images/center/button_in_delete.gif' align='absmiddle' border='0'>^javascript:insDelete(&#39;"+ht.get("REG_CODE")+"&#39;,&#39;"+ht.get("SEQ")+"&#39;)^_self";
				
				reg_dt = (ht.get("VALUE05")+"").substring(0,4)+"-"+(ht.get("VALUE05")+"").substring(4,6)+"-";
				reg_dt += (ht.get("VALUE05")+"").substring(6,8)+" "+(ht.get("VALUE05")+"").substring(8,10)+"��";
				reg_dt += (ht.get("VALUE05")+"").substring(10,12)+"��";
				
				count++;
				 
				//ins_excel_com �ߺ� üũ
				int com_over_cnt =  ic_db.getCheckOverInsExcelCom("�輭", (String)ht.get("REG_CODE"), (String)ht.get("SEQ"));
				if(com_over_cnt > 0) bgcolor_count2++;
				
			  /*  if(String.valueOf(ht.get("VALUE06")).equals("���ڽ�")) {
			        if(ht.get("BLACKBOX_YN").equals("y") || ht.get("BLACKBOX_YN").equals("Y")) {
			        	bgcolor_count3++;
			    	}
			    } */
			   
				
				if(String.valueOf(ht.get("VALUE06")).equals("���ɹ���") || String.valueOf(ht.get("VALUE06")).equals("���ɺ���")
						|| String.valueOf(ht.get("VALUE06")).equals("����")) {
				    if(ht.get("AGE_SCP").equals(ht.get("VALUE08"))) {
				    	bgcolor_count3++;
				    }
				}
				
			 	if(String.valueOf(ht.get("VALUE06")).equals("�빰���Աݾ�") || String.valueOf(ht.get("VALUE06")).equals("�빰���")
						|| String.valueOf(ht.get("VALUE06")).equals("�빰")) {
				    if(ht.get("VINS_GCP_KD").equals(ht.get("VALUE08"))) {
				    	bgcolor_count3++;
				    }
				}
			 	
				if(String.valueOf(ht.get("VALUE06")).equals("��������������") || String.valueOf(ht.get("VALUE06")).equals("��������������Ư��") 
						||String.valueOf(ht.get("VALUE06")).equals("��������������Ư��") || String.valueOf(ht.get("VALUE06")).equals("������")) {
				    if(ht.get("COM_EMP_YN").equals(ht.get("VALUE08"))) {
				    	bgcolor_count3++;
				    }
				}
				
				if(!String.valueOf(ht.get("INS_CON_NO")).contains("P")){
					bgcolor_count4++;
				}
				
				//ins_com_excel ���� �ߺ��� Ȯ��
				com_over_cnt =  ic_db.getCheckOverInsExcelCom2(String.valueOf(ht.get("INS_CON_NO")),String.valueOf(ht.get("ENP_NO")),String.valueOf(ht.get("CAR_MNG_ID")),String.valueOf(ht.get("VALUE07")),String.valueOf(ht.get("VALUE08")));
				if(com_over_cnt > 1){ 
					bgcolor_count3++;
				}
				
				if( String.valueOf(ht.get("VALUE01")).equals("������ ��������") || String.valueOf(ht.get("VALUE01")).equals("������� �Ϸ��� ���� ���� üũ���")
					||String.valueOf(ht.get("VALUE01")).equals("������� �������� ���� ���� ���") || String.valueOf(ht.get("VALUE01")).equals("������� ������ ���� ���")	
					||String.valueOf(ht.get("VALUE01")).equals("����Ʈ ������� �Ϸ��� ���� ���� üũ���") || String.valueOf(ht.get("VALUE01")).equals("26������ ������ ������ ���� �뺸")
					||String.valueOf(ht.get("VALUE01")).equals("�������� ���� �뺸") 
						){
					firm_nm = "(��)�Ƹ���ī";
					enp_no= "1288147957";
				}
				
				if(String.valueOf(ht.get("VALUE06")).equals("������") && String.valueOf(ht.get("VALUE08")).contains("/") ){
					String insInfo[] = String.valueOf(ht.get("VALUE13")).split("/");
					String firm_emp_nm ="";
					//String enp_no ="";
					String age_scp ="";
					String vins_gcp_kd ="";
					String com_emp_yn ="";
					
					if(insInfo.length == 7){// '/' �����ڰ� 7���� ������������
						firm_emp_nm = insInfo[0]+"/"+insInfo[1];      
						enp_no = insInfo[2];  
						age_scp = insInfo[3];      
						vins_gcp_kd = insInfo[4];      
						com_emp_yn = insInfo[5];      

					}else if(insInfo.length == 6){ //'/' �����ڰ� 6���� ������������
						firm_emp_nm = insInfo[0];     
						enp_no = insInfo[1];  
						age_scp = insInfo[2];      
						vins_gcp_kd = insInfo[3];      
						com_emp_yn = insInfo[4];     
					}
				
					 
					if(ht.get("FIRM_EMP_NM").equals(firm_emp_nm) && ht.get("INS_ENP_NO").equals(enp_no)
						&& ht.get("AGE_SCP").equals(age_scp) && ht.get("VINS_GCP_KD").equals(vins_gcp_kd)
						&& ht.get("COM_EMP_YN").equals(com_emp_yn)) {
						bgcolor_count3++;
					} 
					
				}
			
		
			
			%>
			
			
			
			<row  id='<%=ht.get("REG_CODE")%>_<%=ht.get("SEQ")%>' 
			 <%if(bgcolor_count >0 || bgcolor_count3 > 0 ){%> style="background-color:#FFAB98;" <%}%>>
				<cell><![CDATA[]]></cell>
				<cell <%if(ht.get("INS_CHANGE_FLAG").equals("N")){%> style="background-color:red;" <%}%>><![CDATA[<%=ht.get("VALUE01")%>]]></cell>
				<cell><![CDATA[<%=reg_dt%>]]></cell>
				<cell><![CDATA[<%=count%>]]></cell>
				<cell><![CDATA[<%=car_no%>]]></cell>
				<cell	<%if(bgcolor_count4>0){%> style="color:blue;" <%}%> ><![CDATA[<%=ht.get("INS_CON_NO")%>]]></cell>
				<cell><![CDATA[<%=firm_nm%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NM")%>]]></cell>
				<cell><![CDATA[<%=enp_no%>]]></cell>
				<cell><![CDATA[<%=AddUtil.ChangeDate2(ht.get("INS_START_DT")+"")%>]]></cell>
				<cell><![CDATA[<%=AddUtil.ChangeDate2(ht.get("INS_EXP_DT")+"")%>]]></cell>
				<cell   <%if(bgcolor_count2>0){%> style="color:blue;" <%}%> ><![CDATA[<%=ht.get("VALUE06")%>]]></cell>
				<cell><![CDATA[<%=ht.get("VALUE07")%>]]></cell>
				<cell><![CDATA[<%=ht.get("VALUE08")%>]]></cell>
				<cell><![CDATA[<%=delete%>]]></cell>
				<cell><![CDATA[<%=ht.get("CH_DT")%>]]></cell>
			</row>
	
<%}
		
}%>

</rows>	