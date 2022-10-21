<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*,java.text.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.insur.*, acar.cont.*"%> 
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<!--Grid-->
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/dhtmlxgrid.css" />
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/skins/web/dhtmlxgrid_rendering.css"/>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_deprecated.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_export.js"></script>


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
	boolean result =false;
	if(!st_dt.equals("")) st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) end_dt = AddUtil.replace(end_dt, "-", "");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsComDatabase ic_db = InsComDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	//System.out.println(dt+","+st_dt+","+end_dt+","+gubun1+","+gubun2+","+t_wd);
	
	String result_value = "";
	
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
	String reg_dt ="";
	int com_over_cnt = 0;
	
	 Date d = new Date();
	 Date t = new Date(d.getTime()+(1000*60*60*24*+1));
	 SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	 String sysdate =   sdf.format(d);	
	 String tomorrow =   sdf.format(t);	
	
	int count = 0;
	%>
	</head>
	<body leftmargin="15">
	<form action="/acar/ins_mng/ins_c2_frame.jsp" id="form1" name="form1" method="POST" target="c_foot">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="br_id" value="<%=br_id%>">
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type='hidden' name='dt' value='<%=dt%>'>
	<input type='hidden' name='st_dt' value='<%=st_dt%>'>
	<input type='hidden' name='end_dt' value='<%=end_dt%>'>
	<input type='hidden' name='gubun1' value='<%=gubun1%>'>
	<input type='hidden' name='gubun2' value='<%=gubun2%>'>
	<input type='hidden' name='t_wd' value='<%=t_wd%>'>
	
	<table border="1" cellspacing="0" cellpadding="0" width=700>
	<tr>
		<td width='50' align='center' style="font-size : 8pt;">����</td>
		<td width='100' align='center' style="font-size : 8pt;">����ȣ</td>
		<td width='250' align='center' style="font-size : 8pt;">ó�����</td>
		<td width='100' align='center' style="font-size : 8pt;">����ڵ�</td>
		<td width='50' align='center' style="font-size : 8pt;">������</td>
		<td width='50' align='center' style="font-size : 8pt;">���</td>
	</tr>  	
	
	<%
	
	if(jarr_size > 0) {

		for(int i = 0 ; i < jarr_size ; i++) {
			result =false;
				
			Hashtable ht = (Hashtable)jarr.elementAt(i);
			
				if(!String.valueOf(ht.get("VALUE01")).equals("�߰� ��ϰ�") && !String.valueOf(ht.get("VALUE01")).equals("��������̰���")){
					//����1 �뿩���� �� ������ ������ ��� ������ ����
					if(String.valueOf(ht.get("VALUE01")).equals("����1 �뿩����") && String.valueOf(ht.get("VALUE06")).equals("������")){
						if(String.valueOf(ht.get("CAR_ST")).equals("3")){ 
						//	boolean insExCh = ai_db.changeInsExcel(String.valueOf(ht.get("REG_CODE")), String.valueOf(ht.get("SEQ")), "Y");
							continue;
						}
					}
					
					if(!String.valueOf(ht.get("VALUE01")).equals("����������� ���������뺸��") ){
						if(!String.valueOf(ht.get("VALUE01")).equals("���°� ���")){	
							if( String.valueOf(ht.get("VALUE06")).equals("������������") ||	String.valueOf(ht.get("VALUE06")).equals("������")){
								if(!String.valueOf(ht.get("VALUE01")).contains("����1")){
									//boolean insExCh = ai_db.changeInsExcel(String.valueOf(ht.get("REG_CODE")), String.valueOf(ht.get("SEQ")), "Y");
									continue;
								}
							}
						}
					}
									
					
					// ���������������� BASE���������� ����Ʈ�� 2�� �����°��, �������������� ����Ʈ���� ����
					
					if( String.valueOf(ht.get("VALUE06")).equals("��������������")){
						 int over_cnt =  ic_db.getCheckOverInsExcel(String.valueOf(ht.get("CAR_MNG_ID")));
						if(over_cnt > 1){
							//boolean insExCh = ai_db.changeInsExcel(String.valueOf(ht.get("REG_CODE")), String.valueOf(ht.get("SEQ")), "Y");
							continue;
						} 
					}
					
					
					//����ȭ�� ������ ����Ʈ���� ����
					if(!String.valueOf(ht.get("VALUE01")).equals("����������� ���������뺸��") ){
						if(!String.valueOf(ht.get("INS_CON_NO")).contains("P")){
							if(String.valueOf(ht.get("VALUE06")).equals("������")){
								//boolean insExCh = ai_db.changeInsExcel(String.valueOf(ht.get("REG_CODE")), String.valueOf(ht.get("SEQ")), "Y");
								continue;
							}
						}
					}
					
					
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
							continue;
						} 
					}
					
					//�縮�� �뿩�����ε� Ź���Ƿ� ��� �϶��� �����ε��� ����Ȯ��
						//����Ÿ����
						ContEtcBean cont_etc = a_db.getContEtc(String.valueOf(ht.get("RENT_MNG_ID")) ,String.valueOf(ht.get("RENT_L_CD")) );
						
					/* �����ε����ڰ� ���� ��� ����Ʈ�� �ȳ�����  -�Ʒ���û���� �����*/
					/* ��� ���� �����ε��� �Ǵ� �����ε������� �߰��ϰ� ������ 
					      ������ڷ� ã�� ���� ã�� ��¥ �������� ���� ����Ʈ�� ��������- 2020616 �������ڿ�û */
					/* �뿩�����ϵ� �߰� 1.�����ε��� 2.�����ε������� 3.�뿩������ 4.�����   */
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
						}	*/
					 	
	 	 			 	SimpleDateFormat sdf2 = new SimpleDateFormat("yyyyMMdd");
			 			Date stand_dt_date =   sdf2.parse(stand_dt);
			 			Date stand_dt_yesterdate = new Date(stand_dt_date.getTime()-(1000*60*60*24*+1));
		 			 	String stand_dt_yesterday = sdf2.format(stand_dt_yesterdate);
					
		 			 	//������/�ָ��� ��� ������ ó��
		 			 	stand_dt_yesterday = ai_db.getValidDt(stand_dt_yesterday).replaceAll("-", "");
		 			 	
		 			 	if(Integer.parseInt(stand_dt_yesterday) > (Integer.parseInt(sysdate))){
							//System.out.println(String.valueOf(ht.get("CAR_NO"))+" "+stand_dt_yesterday + ":" + sysdate);
							continue;
						}   
		 			 	
						//USE_YN �� null ���� ��� (�°谡 �������̹Ƿ� ���� ���� �Ϸᰡ �ȵȰ�)
						if(String.valueOf(ht.get("USE_YN")).equals("") ){
							continue;
						}
						
						//������ ��� �������� N�̿��� ������ ����û�ÿ��� Y����
						/* if(!String.valueOf(ht.get("CLIENT_ST")).equals("1") && !String.valueOf(ht.get("CLIENT_ST")).equals("3")){
							if(cont_etc.getCom_emp_yn().equals("Y")){
								if(cont_etc.getCom_emp_sac_id().equals("")){
									continue;
								}
							}
						} */
				}
				
				// �ߺ��Ǵ� ����Ʈ ����
				//if(	ic_db.getCheckOverInsExcel( String.valueOf(ht.get("CAR_MNG_ID")), String.valueOf(ht.get("VALUE07")),String.valueOf(ht.get("VALUE08"))) > 1 ) continue;
				
				count++;
				
				String reg_code =  (String)ht.get("REG_CODE");
				int seq = Integer.parseInt((String)ht.get("SEQ"));
				
				//�ߺ� üũ
				int over_cnt =  ic_db.getCheckOverInsExcelCom("�輭", reg_code, (String)ht.get("SEQ"));
				if(over_cnt > 0){
					result_value = "�̹� ó���� �� �Դϴ�";
				}
				
				
				if(String.valueOf(ht.get("VALUE06")).equals("��������")) {
				    if(ht.get("CONR_NM").equals(ht.get("value08"))) {
				        result_value = "��ݿ����� ó���Ȱ��Դϴ�";
				        over_cnt = 1;
				    }
				}
				
				/* if(String.valueOf(ht.get("VALUE06")).equals("�Ǻ�����")) {
				    if(ht.get("CON_F_NM").equals(ht.get("value08"))) {
				        result_value = "��ݿ����� ó���Ȱ��Դϴ�";
				        over_cnt = 1;
				    }
				} */
				
				if(String.valueOf(ht.get("VALUE06")).equals("���ɹ���") || String.valueOf(ht.get("VALUE06")).equals("���ɺ���")
						|| String.valueOf(ht.get("VALUE06")).equals("����")) {
				    if(ht.get("AGE_SCP").equals(ht.get("VALUE08"))) {
				        result_value = "��ݿ����� ó���Ȱ��Դϴ�";
				        over_cnt = 1;
				    }
				}
				
				if(String.valueOf(ht.get("VALUE06")).equals("�빰���Աݾ�") || String.valueOf(ht.get("VALUE06")).equals("�빰���")
						|| String.valueOf(ht.get("VALUE06")).equals("�빰")) {
				    if(ht.get("VINS_GCP_KD").equals(ht.get("VALUE08"))) {
				        result_value = "��ݿ����� ó���Ȱ��Դϴ�";
				        over_cnt = 1;
				    }
				}
				
				if(String.valueOf(ht.get("VALUE06")).equals("�ڱ��ü���")) {
				        result_value = "��ݿ����� ó���Ȱ��Դϴ�";
				        over_cnt = 1;
				}
				
			    if( String.valueOf(ht.get("VALUE06")).equals("���ڽ�") ) {
			        //if(ht.get("BLACKBOX_YN").equals("y") || ht.get("BLACKBOX_YN").equals("Y"))
					String ins_value = "";
			        String blackbox_nm = String.valueOf(ht.get("BLACKBOX_NM"));
			       	if( blackbox_nm.contains(" ") ) blackbox_nm = blackbox_nm.replace(" ", "/");
					if( blackbox_nm.contains("-") ) blackbox_nm = blackbox_nm.replace("-", "/");
			       	String blackbox_no = String.valueOf(ht.get("BLACKBOX_NO"));
			       	ins_value = "����/" + blackbox_nm + "/" + blackbox_no;
			       	
			       	if( String.valueOf(ht.get("VALUE08")).equals(ins_value) ){
			       		result_value = "��ݿ����� ó���Ȱ��Դϴ�";
			            over_cnt = 1;
			       	} else if( ic_db.getCheckOverInsExcelCom(String.valueOf(ht.get("CAR_MNG_ID")), String.valueOf(ht.get("INS_ST")), String.valueOf(ht.get("VALUE07")), String.valueOf(ht.get("VALUE08"))) > 0){
			       		result_value = "�̹� ó���� ���Դϴ�.";
			       		over_cnt = 1;
			       	}
			    }
				
				if(String.valueOf(ht.get("VALUE06")).equals("��������������") || String.valueOf(ht.get("VALUE06")).equals("��������������Ư��") 
						||String.valueOf(ht.get("VALUE06")).equals("��������������Ư��") || String.valueOf(ht.get("VALUE06")).equals("������")) {
				    if(ht.get("COM_EMP_YN").equals(ht.get("VALUE08"))) {
				        result_value = "��ݿ����� ó���Ȱ��Դϴ�";
				        over_cnt = 1;
				    }
				}
				
				if(String.valueOf(ht.get("VALUE06")).equals("������������") || String.valueOf(ht.get("VALUE06")).equals("������")) {
				    if(ht.get("FIRM_EMP_NM").equals(ht.get("VALUE08"))) {
				        result_value = "��ݿ����� ó���Ȱ��Դϴ�";
				        over_cnt = 1;
				    }
				}
				
				/* if(!String.valueOf(ht.get("INS_CON_NO")).contains("P")){
					result_value = "����ȭ���� ���õ� �� �Դϴ�";
			        over_cnt = 1;
				} */
				
				//ins_com_excel ���� �ߺ��� Ȯ��
				if(!String.valueOf(ht.get("VALUE06")).equals("��������������") && !String.valueOf(ht.get("VALUE06")).equals("��������������Ư��") 
						&& !String.valueOf(ht.get("VALUE06")).equals("��������������Ư��") && !String.valueOf(ht.get("VALUE06")).equals("������")
						&& !String.valueOf(ht.get("VALUE06")).equals("���ɹ���") && !String.valueOf(ht.get("VALUE06")).equals("���ɺ���")
						&& !String.valueOf(ht.get("VALUE06")).equals("����")
					) 
				{
					
					com_over_cnt =  ic_db.getCheckOverInsExcelCom2(String.valueOf(ht.get("INS_CON_NO")),String.valueOf(ht.get("ENP_NO")),String.valueOf(ht.get("CAR_MNG_ID")),String.valueOf(ht.get("VALUE07")),String.valueOf(ht.get("VALUE08")));
					if(com_over_cnt > 0){ 
						 result_value = "�Ϸ�ó���� ���� ���Դϴ�";
						 over_cnt = 1;
					}
				}
				
				if(String.valueOf(ht.get("VALUE13")).contains("/") ){
					String insInfo[] = String.valueOf(ht.get("VALUE13")).split("/");
					String firm_emp_nm ="";
					String enp_no ="";
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
					        result_value = "��ݿ����� ó���Ȱ��Դϴ�";
					        over_cnt = 1;
					}
				}
				
			
			if(over_cnt > 0){
			}else{
				result = ic_db.call_sp_ins_cng_req_com(reg_code,seq);
				if(!result){
					result_value = "��� �����Դϴ�.";	
				}else{
				/* 	if(String.valueOf(ht.get("REG_CODE")).equals("ICQ-A33381CDEFGHIJKL")){
					} */
					
					result_value = "���� ��ϵǾ����ϴ�.";	
				}
			} 
			%>
			<tr>
				<td align='center' style="font-size : 8pt;"><%=count%></td>
			    <td align='center' style="font-size : 8pt;"><%=ht.get("CAR_NO")%></td>
			    <td align='center' style="font-size : 8pt;"><%if(!result){%><font color=red><%=result_value%></font><%}else{%><%=result_value%><%}%></td>
			    <td align='center' style="font-size : 8pt;"><%=reg_code%></td>
			    <td align='center' style="font-size : 8pt;"><%=seq%></td>
			    <td align='center' style="font-size : 8pt;"><%=result%></td>
			</tr>

			<%
		//}
		}

	}
%>
		</table>
	</form>
</body>

</html>