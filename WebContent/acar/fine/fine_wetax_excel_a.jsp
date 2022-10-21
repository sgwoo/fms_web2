<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.customer.*, acar.forfeit_mng.*, acar.user_mng.*"%>
<jsp:useBean id="cu_db" class="acar.customer.Customer_Database" scope="page"/>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<%
	
	
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String result[]  = new String[value_line];
	String value11[]  = request.getParameterValues("value11"); // ���ݳ���
	String value8[]  = request.getParameterValues("value8"); // ������ȣ
	String value5[]  = request.getParameterValues("value5"); // ������ȣ
	String value4[]  = request.getParameterValues("value4"); // �������
	String value3[]  = request.getParameterValues("value3"); // �����Ͻ�
	String value7[]  = request.getParameterValues("value7"); // �ΰ���
	String value6[]  = request.getParameterValues("value6");  // ���αⰣ
	String value1[]	 = request.getParameterValues("value1");  // �ΰ����

	int flag = 0;
	int error = 0;
	int seq = 0;
	int seq2 = 0;
	int count = 0;
	String reg_code  = Long.toString(System.currentTimeMillis());
	String car_no 		= "";
	String js_dt 		= "";
	String c_id = "";
	String m_id = "";
	String l_cd = "";
	String mng_id = "";
	String seq_no = "";
	String paid_no ="";
	String paid_no2 ="";
	String vio_cont = "";
	String s_cd = "";
	String fine_off ="";
	String gov_nm ="";
	String rent_st = "";
	String vio_dt = "";
	String vio_pla = "";
	
	LoginBean login = LoginBean.getInstance();
	//���·�����
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	for(int i=start_row ; i < value_line ; i++){
		fine_off		= value8[i] == null?"":value8[i].substring(0,7);
		Hashtable ht3 = cu_db.fine_off_search_wetax(fine_off);
		gov_nm = String.valueOf(ht3.get("GOV_ID"));
		
		if(value5[i] == null || value5[i].equals("") || value5[i].equals(" ") ||
		   value4[i] == null || value4[i].equals("") || value4[i].equals(" ") ||
		   value3[i] == null || value3[i].equals("") || value3[i].equals(" ")) {
			
			HashMap<String, Object> map= new HashMap<>();
	   		map.put("car_no",value5[i]);
	   		map.put("gov_nm",gov_nm);
	   		map.put("paid_no",value8[i]);
	   		map.put("vio_pla",value4[i]);
	   		map.put("vio_dt",value3[i]);
	   		map.put("vio_cont",value11[i]);
	   		map.put("paid_amt",AddUtil.parseInt(value7[i]));
	   		map.put("paid_end_dt",value6[i]);
	   		map.put("impose_dt",value1[i]);
	   		
	   		// �ӽ� ���̺� ������ �ߺ� �˻�
			Vector finesTemp = a_fdb.getFineTempList((String)map.get("paid_no"));
			int finesTempSize = finesTemp.size();
			if(finesTempSize <= 0) {
				a_fdb.insertFineWetaxTemp(map);
			}
			
			result[i] = "���� ��� /  ���� �Ͻ� / ���� ��ȣ �� ���� �����Ͱ� �־� �ӽ� ���̺� �����߽��ϴ�.";
			
			continue;
		}
		
		car_no 			= value5[i] == null?"":value5[i];
		vio_pla			= value4[i] == null?"":value4[i];
		vio_dt			= value3[i]  == null?"":value11[i];
		try{
			js_dt			= value3[i] == null?"":value3[i].substring(0,8);
		} catch (IndexOutOfBoundsException e) {
			result[i] = "�����Ͻð� �߸��Ǿ����ϴ�. Ȯ�� �� �ٽ� ������ּ���.";
			continue;
		}
		
		//�ϰ���Ͽ����� ���� �ڵ����� fetch�ؿ��� �������� �߸��� �������� �����ü� ����. -> �̷��ǵ鸸 üũ�� ��Ȯ�� �� ���� ��������ϵ��� ����.(20190724)
		if(!car_no.equals("") && !js_dt.equals("")){
			Vector vt_s = a_fdb.getFineSearchContList(car_no, js_dt);
			if(vt_s.size()>1){
				result[i] = "���� �ߺ� �˻��Ǿ� �ϰ� ��Ͽ��� ���ܵǾ����ϴ�. ����������ּ���.";
				continue;
			}
		}
		
	//	Hashtable ht = cu_db.speed_Serach(car_no, js_dt); 
	// VVV ����ڰ� ��¥ ���Է� ������ �������� ��ȸ�ɼ� �ִµ� 1�Ǹ� fetch�ǰ� �װ��� �߸��� �����ϼ� �־ ����(20190829)
		Vector vt_s2 = cu_db.getFine_maker(car_no, js_dt); 
		if(vt_s2.size() == 1){
			for(int j=0; j<vt_s2.size();j++){
				Hashtable ht_s2 = (Hashtable)vt_s2.elementAt(j);
				
				c_id 		= String.valueOf(ht_s2.get("CAR_MNG_ID")); 
				m_id 	= String.valueOf(ht_s2.get("RENT_MNG_ID")); 
				l_cd 		= String.valueOf(ht_s2.get("RENT_L_CD")); 
				mng_id = String.valueOf(ht_s2.get("MNG_ID")); 
				s_cd 		= String.valueOf(ht_s2.get("RENT_S_CD"));		
				rent_st = String.valueOf(ht_s2.get("RENT_ST"));
			}
		}else{
			result[i] = "���� �ߺ� �˻��Ǿ� �ϰ� ��Ͽ��� ���ܵǾ����ϴ�. ���� ������ּ���.";
			continue;			
		}

		if(c_id.equals("null")){
				result[i] = "��� �� ���� �߻�";
				continue;
			}

			f_bean.setFine_st		("1");
			f_bean.setVio_dt		(value3[i] ==null?"":value3[i]); //��������
			f_bean.setVio_pla		(value4[i] ==null?"":value4[i]); //�������
			f_bean.setVio_cont		(value11[i] ==null?"":value11[i]); //���ݳ���
			f_bean.setPaid_st		("1");		//�����ں���
			f_bean.setPaid_end_dt	(value6[i] ==null?"":value6[i]); //���α���
			f_bean.setPaid_amt		(value7[i] ==null?0: AddUtil.parseDigit(value7[i]));  //�ΰ��ݾ�
			f_bean.setPol_sta		(gov_nm);  //û�����-��Ⳳ�ε���(��)
			f_bean.setPaid_no		(value8[i] ==null?"":value8[i]);  //��������ȣ
			f_bean.setFault_st		("1");  //���Ǳ���
			f_bean.setNote			("���ý� ���� �ϰ� ���");
			f_bean.setUpdate_id		(user_id);
			f_bean.setUpdate_dt		(AddUtil.getDate());
			f_bean.setMng_id		(mng_id);
			f_bean.setCar_mng_id	(c_id);
			f_bean.setRent_mng_id	(m_id);
			f_bean.setRent_l_cd		(l_cd);
			f_bean.setRent_s_cd		(s_cd);
			f_bean.setReg_id		(user_id);
			f_bean.setNotice_dt		(AddUtil.getDate());
			f_bean.setRent_st		(rent_st);
			
			//�ߺ�üũ
			Vector c_fines = a_fdb.getFineCheckList(f_bean.getCar_mng_id(), f_bean.getVio_dt());
			int c_fine_size = c_fines.size();
			
			if(c_fine_size==0){
				seq = a_fdb.insertForfeit(f_bean);
				result[i] = "���� ó���Ǿ����ϴ�.";
				// �̵�� ����Ʈ �÷��� ����
		   		HashMap<String, Object> map= new HashMap<>();
		   		map.put("paid_no",value8[i]);
				
				a_fdb.updateFineTemp2RegYn((String)map.get("paid_no"));
				
			}else{
				for (int j = 0 ; j < 1 ; j++){
        	Hashtable c_fine = (Hashtable)c_fines.elementAt(j);
        	seq = AddUtil.parseInt(String.valueOf(c_fine.get("SEQ_NO")));
        	boolean flag6 = a_fdb.updateForfeitReReg(f_bean.getCar_mng_id(), seq, f_bean.getUpdate_id());
        	result[i] = "�̹� ��ϵ� ���·��Դϴ�.";
        }
			}
	
			if(seq > 0){
// 				result[i] = "���� ó���Ǿ����ϴ�.";
			}else{
				result[i] = "���� �߻�!";
			}			
	
	}
	String ment = "";
	for(int i=start_row ; i < value_line ; i++){
		if(!result[i].equals("")) ment += result[i]+"";
	}
	int result_cnt = 0;
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>���� ���� �о� ���·�(û��)������ ����ϱ�
</p>
<form action="fine_wetax_excel_result.jsp" method='post' name="form1">
<input type='text' name='start_row' value='<%=start_row%>'>
<input type='text' name='value_line' value='<%=value_line%>'>
<%	for(int i=start_row ; i < value_line ; i++){
// 		if(result[i].equals("���� ó���Ǿ����ϴ�.")) continue;
		result_cnt++;%>
<input type='text' name='car_no'     value='<%=value5[i] ==null?"":value5[i]%>'>
<input type='text' name='js_dt'     value='<%=value3[i] ==null?"":value3[i]%>'>
<input type='text' name='result'     value='<%=result[i]%>'>
<%	}%>
<input type='text' name='result_cnt' value='<%=result_cnt%>'>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
		document.form1.submit();

//-->

</SCRIPT>
</BODY>
</HTML>