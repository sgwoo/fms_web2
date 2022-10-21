<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*, acar.cont.*, acar.memo.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_cd 		= request.getParameter("s_cd")==null?"":request.getParameter("s_cd");	
	String c_id 		= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");	
	String brch_id 		= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");	
	String mng_br_id 	= request.getParameter("mng_br_id")==null?"":request.getParameter("mng_br_id");	
		
	String park 		= request.getParameter("park")==null?"":request.getParameter("park");
	String park_cont 	= request.getParameter("park_cont")==null?"":request.getParameter("park_cont");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	int count = 1;
	int count2 = 0;
	
	//����ġ ����
	//count = rs_db.updateCarPark(c_id, park, park_cont);
	count = rs_db.updateCarPark2(c_id, park, park_cont, user_id);
	
	
	//��������Ȳ - ����� ������ ����
	if(park.equals("1") || park.equals("3") || park.equals("7") || park.equals("8")|| park.equals("4") || park.equals("9") || park.equals("12") || park.equals("13") || park.equals("14") ){
		Hashtable ht2 = pk_db.getRentParkIOSearch2(c_id);
		count2 = pk_db.UpdateParkIO(String.valueOf(ht2.get("CAR_MNG_ID")));	
	}
	
		
	//����ġ�� Ʋ�� ���������� ��� ��������  ���� - 2012-10-09 -  ��ġ�� ��Ÿ�� ���� ó��
	

	String n_mng_br_id = "";
	String n_user_id = "";	
			
	
	if(park.equals("1") || park.equals("5") || park.equals("10") || park.equals("15")){	
		n_mng_br_id = "S1";		
		n_user_id = nm_db.getWorkAuthUser("�����������");	
	//�λ����� park_in ('3', '7', '8' )	
	}else if(park.equals("3") || park.equals("7") || park.equals("8")){	
		n_mng_br_id = "B1";		
		n_user_id = nm_db.getWorkAuthUser("�λ�������");	
	//�������� park_in ('4', '9') 
	}else if(park.equals("4") || park.equals("9")){	
		n_mng_br_id = "D1";		
		n_user_id = nm_db.getWorkAuthUser("����������");	
	}else if(park.equals("12") || park.equals("14")){	
		n_mng_br_id = "J1";		
		n_user_id = nm_db.getWorkAuthUser("����������");	
	}else if(park.equals("13")){	
		n_mng_br_id = "G1";		
		n_user_id = nm_db.getWorkAuthUser("�뱸������");	
	}	
		
	Hashtable cont = a_db.getContViewUseYCarCase(c_id);
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(String.valueOf(cont.get("RENT_MNG_ID")), String.valueOf(cont.get("RENT_L_CD")));
	
	if(cont_etc.getRent_mng_id().equals("")){
	
		cont_etc.setMng_br_id		(n_mng_br_id);
	
		//=====[cont_etc] update=====
		cont_etc.setRent_mng_id	(String.valueOf(cont.get("RENT_MNG_ID")));
		cont_etc.setRent_l_cd	(String.valueOf(cont.get("RENT_L_CD")));
		boolean flag2 = a_db.insertContEtc(cont_etc);
	}else{
	
		String o_mng_br_id = cont_etc.getMng_br_id();
		
		if(!o_mng_br_id.equals(n_mng_br_id)){
			
			//�������� �����̷µ�� & �������� ���� ����
			LcRentCngHBean bean = new LcRentCngHBean();	
			bean.setRent_mng_id	(String.valueOf(cont.get("RENT_MNG_ID")));
			bean.setRent_l_cd	(String.valueOf(cont.get("RENT_L_CD")));
			bean.setCng_item	("mng_br_id");
			bean.setOld_value	(o_mng_br_id);
			bean.setNew_value	(n_mng_br_id);
			bean.setCng_cau		("������ ����ġ ����");
			bean.setCng_id		(ck_acar_id);
			bean.setRent_st		(String.valueOf(cont.get("FEE_RENT_ST")));
			bean.setS_amt		(0);
			bean.setV_amt		(0);	
			boolean flag = a_db.updateLcRentCngH(bean);
			
			String cont_memo 		= "[������ ����ġ ����] "+car_no+" �� ����ġ�� ����Ǿ����ϴ�. �������� �� ��������ڸ� �������ּ���.";
								
			
		}		
	}
		
	
%>
<script language='javascript'>
<%	if(count == 1){%>
		alert('���������� ó���Ǿ����ϴ�');
		parent.window.close();
		parent.opener.location.reload();
<%	}else{ //����%>
		alert('ó������ �ʾҽ��ϴ�\n\n�����߻�!');
<%	}%>
<%	if(count2 == 1){%>
		parent.window.close();
		parent.opener.location.reload();
<%	}%>
</script>
</body>
</html>
