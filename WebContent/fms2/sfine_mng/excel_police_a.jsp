<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.customer.*, acar.forfeit_mng.*, acar.user_mng.*"%>
<jsp:useBean id="cu_db" class="acar.customer.Customer_Database" scope="page"/>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<%//@ include file="/acar/cookies.jsp" %>
<%
	int row_size		= request.getParameter("row_size")			== null ? 0 : AddUtil.parseInt(request.getParameter("row_size")); //���
	int col_size		= request.getParameter("col_size")			== null ? 0 : AddUtil.parseInt(request.getParameter("col_size")); //����
	int start_row		= request.getParameter("start_row")			== null ? 0 : AddUtil.parseInt(request.getParameter("start_row")); //������
	int value_line	= request.getParameter("value_line")		== null ? 0 : AddUtil.parseInt(request.getParameter("value_line")); //��������Ÿ�ִ����

//	String car_mng_id = request.getParameter("car_mng_id")	== null ? "" : request.getParameter("car_mng_id");
	String gubun1 		= request.getParameter("gubun1")			== null ? "" : request.getParameter("gubun1");
	String user_id 		= request.getParameter("user_id")			== null ? "" : request.getParameter("user_id");

	String result[]  = new String[value_line];

	String value0[]  = request.getParameterValues("value0");	// ����ڸ�		00
	String value1[]  = request.getParameterValues("value1");	// ����ڹ�ȣ	01
	String value2[]  = request.getParameterValues("value2");	// ���·����	02
	String value3[]  = request.getParameterValues("value3");	// �����Ͻ�		03
	String value4[]  = request.getParameterValues("value4");	// �������		04
	String value5[]  = request.getParameterValues("value5");	// ������ȣ		05
	String value6[]  = request.getParameterValues("value6");	// ���α���		06
	String value7[]  = request.getParameterValues("value7");	// ���αݾ�		07
	String value8[]  = request.getParameterValues("value8");	// ���Ұ���		08
	String value9[]  = request.getParameterValues("value9");	// ������ȭ��ȣ 09
	String value10[]  = request.getParameterValues("value10");	// ���·��ȣ	10
	String value11[]  = request.getParameterValues("value11");	// �����¿�		11

	int flag = 0;
	int error = 0;
	int seq = 0;
	int count = 0;

	String reg_code	= Long.toString(System.currentTimeMillis());

	String car_no		= ""; // ������ȣ 05
	String js_dt		= ""; // �����Ͻ� 03

	String c_id			=	""; // car_mng_id
	String m_id			= ""; // rent_mng_id
	String l_cd			= ""; // rent_l_cd
	String mng_id		= ""; // mng_id
  String s_cd     = ""; // rent_s_cd

	String seq_no		= "";
	String paid_no	= "";
	String paid_no2	= "";
	String vio_cont	= "";
	String fine_off	= ""; // ���Ұ��� 08
	String gov_nm		= ""; // gov_id
//	String vio_dt		= "";

//	LoginBean login = LoginBean.getInstance();

//	if(user_id.equals("")) user_id = login.getCookieValue(request, "acar_id");

	for (int i = start_row; i < value_line; i++) {
/* ####		
		car_no 		= value3[i] ==null?"":value3[i].trim();
		js_dt			= value0[i] ==null?"":value0[i].substring(0,8);
		fine_off	= value6[i] ==null?"":value6[i];
*/
		car_no		= (value5[i] == null) ? "" : value5[i].trim();
		js_dt			= (value3[i] == null) ? "" : value3[i].substring(0, 8);
		fine_off	= (value8[i] == null) ? "" : value8[i];

		Hashtable ht3 = cu_db.fine_off_search(fine_off);

		gov_nm = String.valueOf(ht3.get("GOV_ID"));

		// ������ȣ�� 1�� �̻��� car_mng_id ��������
    //------------------------------------------------------------------- 
		Hashtable ht_car_mng_id = cu_db.newGetCarMngId(car_no);  //

    if (ht_car_mng_id.size() < 1) {
      result[i] = "����� ���� �߻�";

      continue;
    }

    String query_car_mng_id = "";

    for (int j = 0; j < ht_car_mng_id.size(); j++) {
    	query_car_mng_id += "'" + ht_car_mng_id.get(String.valueOf(j)) + "'";

      if (j != (ht_car_mng_id.size() - 1)) { 
      	query_car_mng_id += ", ";
      }
    }

    query_car_mng_id = "(" + query_car_mng_id + ")";
    //------------------------------------------------------------------- 


    // car_mng_id�� 1�� �̻��� rent_mnt_id ��������
    //------------------------------------------------------------------- 
	/*
    Hashtable ht_rent_mng_id = cu_db.newGetRentMngId(query_car_mng_id);

    if (ht_rent_mng_id.size() < 1) {
    	result[i] = "����� ���� �߻�";

      continue;
    }

    String query_rent_mng_id = "";

    for (int j = 0; j < ht_rent_mng_id.size(); j++) {
    	query_rent_mng_id += "'" + ht_rent_mng_id.get(String.valueOf(j)) + "'";

      if (j != (ht_rent_mng_id.size() - 1)) { 
      	query_rent_mng_id += ", ";
      }
    }

    query_rent_mng_id = "(" + query_rent_mng_id + ")";
	*/
    //------------------------------------------------------------------- 

    Hashtable ht = cu_db.speed_Serach(car_no, js_dt);
//    Hashtable ht = cu_db.newSpeedSearch(car_no, js_dt, query_rent_mng_id);

		c_id		= String.valueOf(ht.get("CAR_MNG_ID"));
		m_id		= String.valueOf(ht.get("RENT_MNG_ID"));
		l_cd		= String.valueOf(ht.get("RENT_L_CD"));
		mng_id	= String.valueOf(ht.get("MNG_ID"));
		s_cd		= String.valueOf(ht.get("RENT_S_CD"));

		if (m_id.equals("null") && l_cd.equals("null")) {
			Hashtable ht2 = cu_db.newSearch2(car_no, js_dt, query_car_mng_id);

			c_id		= String.valueOf(ht2.get("CAR_MNG_ID"));
			m_id		= String.valueOf(ht2.get("RENT_MNG_ID"));
			l_cd		= String.valueOf(ht2.get("RENT_L_CD"));
			mng_id	= String.valueOf(ht2.get("MNG_ID"));
		}

//    if(true) return;

		//���·�����
		AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();

		//��õ���·� ���·� ���ó��
		if (gubun1.equals("2")) {
			if (c_id.equals("null")) {
				result[i] = "����� ���� �߻�";

				continue;
			}

			if (s_cd.equals("") || s_cd.equals("null")) {
				s_cd = "";
			}

//			vio_dt = value0[i] == null ? "" : value0[i];

			f_bean.setFine_st      ("1");
			f_bean.setVio_dt       (value3[i]    == null ? "" : value3[i]);                    //��������
			f_bean.setVio_pla      (value4[i]    == null ? "" : value4[i]);                    //�������
			f_bean.setVio_cont     (value11[i]   == null ? "" : value11[i]);                   //���ݳ���
			f_bean.setPaid_st      ("1");                                                      //�����ں���
			f_bean.setPaid_end_dt  (value6[i]    == null ? "" : value6[i]);                    //���α���
			f_bean.setPaid_amt     (value7[i]    == null ? 0 : AddUtil.parseDigit(value7[i])); //�ΰ��ݾ�
			f_bean.setPol_sta      (gov_nm);                                                   //û�����
			f_bean.setPaid_no      (value10[i]   == null ? "" : value10[i]);                   //��������ȣ
			f_bean.setFault_st     ("1");                                                      //���Ǳ���
			f_bean.setNote         ("�׽�Ʈ�׽�Ʈ�׽�Ʈ");
			f_bean.setUpdate_id    (user_id);
			f_bean.setUpdate_dt    (AddUtil.getDate());
			f_bean.setMng_id       (mng_id);
			f_bean.setCar_mng_id   (c_id);
			f_bean.setRent_mng_id  (m_id);
			f_bean.setRent_l_cd    (l_cd);
			f_bean.setRent_s_cd    (s_cd);
			f_bean.setReg_id       (user_id);
			f_bean.setNotice_dt    (AddUtil.getDate());

			//�ߺ�üũ
			//System.out.println("seq"+i+": "+a_fdb.getFineCheck(f_bean.getCar_mng_id(), f_bean.getVio_dt()));
			//if(a_fdb.getFineCheck(c_id, vio_dt) == 0){
			seq = a_fdb.insertForfeit(f_bean);
			//}

			if(seq > 0) {
				result[i] = "����ó���Ǿ����ϴ�.";
			} else {
				result[i] = "�����߻�!";
			}
		}
	}

	if (true) return;

	String ment = "";
/*
	for(int i=start_row ; i < value_line ; i++){
		if(!result[i].equals("")) ment += result[i]+"";
	}
*/
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
<form action="excel_police_result.jsp" method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
<%	for(int i=start_row ; i < value_line ; i++){
		if(result[i].equals("����ó���Ǿ����ϴ�.")) continue;
		result_cnt++;%>
<input type='hidden' name='car_no'     value='<%=value5[i] ==null?"":value5[i]%>'>
<input type='hidden' name='js_dt'     value='<%=value3[i] ==null?"":value3[i]%>'>
<input type='hidden' name='result'     value='<%=result[i]%>'>
<%	}%>
<input type='hidden' name='result_cnt' value='<%=result_cnt%>'>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
		document.form1.submit();

//-->
</SCRIPT>
</BODY>
</HTML>