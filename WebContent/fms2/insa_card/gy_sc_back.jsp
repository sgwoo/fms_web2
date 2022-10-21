<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*, acar.insa_card.*, acar.car_sche.*" %>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<jsp:useBean id="ic_db" scope="page" class="acar.insa_card.InsaCardDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	LoginBean login = LoginBean.getInstance();
	String acar_id = login.getCookieValue(request, "acar_id");
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_br_id = request.getParameter("s_br_id")==null?"":request.getParameter("s_br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 	= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	

// ���س� �ܱ��� ������ ��Ȳ ����
	int acar_yk0 = 0; //������ȹ
	int acar_y0 = 0; 	//����
	int acar_k0 = 0;	//����
	int acar_c0 = 0;	//�ѹ�
	int acar_b0 = 0;	//�λ�
	int acar_d0 = 0;	//����
	int acar_s0 = 0;	//����
	int acar_j0 = 0;	//����
	int acar_g0 = 0;	//�뱸
	int acar_i0	= 0;	//��õ
	int acar_w0 = 0;	//����
	int acar_gs0 = 0;	//����(����)
	int acar_gr0 = 0;	//����(����)
	int acar_u0 = 0;	//���
	int acar_jr0 = 0;	//����
	int acar_sp0 = 0;	//����
	int acar_it0 = 0;	//IT
	int acar_exec0 = 0;	//�ӿ�
	
	int acar_tot0 = 0;	//�Ұ�

// ���س� ������ ������ ��Ȳ ����	
	int acar_yk1 = 0; //������ȹ
	int acar_y1 = 0; 	//����
	int acar_k1 = 0;	//����
	int acar_c1 = 0;	//�ѹ�
	int acar_b1 = 0;	//�λ�
	int acar_d1 = 0;	//����
	int acar_s1 = 0;	//����
	int acar_j1 = 0;	//����
	int acar_g1 = 0;	//�뱸
	int acar_i1	= 0;	//��õ
	int acar_w1 = 0;	//����
	int acar_gs1 = 0;
	int acar_gr1 = 0;
	int acar_u1 = 0;
	int acar_jr1 = 0;	//����
	int acar_sp1 = 0;	//����
	int acar_it1 = 0;
	int acar_exec1 = 0;	//�ӿ�(20180712)
	
	int acar_tot1 = 0;	//�Ұ�
	
	
	int acar_tot01 = 0;	//�հ�

// ���س�-1 �ܱ��� ������ ��Ȳ ����	
	int acar_yk2 = 0; 
	int acar_y2 = 0; 
	int acar_k2 = 0;
	int acar_c2 = 0;
	int acar_b2 = 0;
	int acar_d2 = 0;
	int acar_s2 = 0;
	int acar_j2 = 0;
	int acar_g2 = 0;
	int acar_i2 = 0;
	int acar_w2 = 0;
	int acar_gs2 = 0;
	int acar_gr2 = 0;
	int acar_u2 = 0;
	int acar_jr2 = 0;	//����
	int acar_sp2 = 0;	//����
	int acar_it2 = 0;
	int acar_exec2 = 0;	//�ӿ�(20180712)
	
	int acar_tot2 = 0;
	
// ���س�-1 ������ ������ ��Ȳ ����
	int acar_yk3 = 0;
	int acar_y3 = 0;
	int acar_k3 = 0;
	int acar_c3 = 0;
	int acar_b3 = 0;
	int acar_d3 = 0;
	int acar_s3 = 0;
	int acar_j3 = 0;
	int acar_g3 = 0;	
	int acar_i3 = 0;
	int acar_w3 = 0;
	int acar_gs3 = 0;
	int acar_gr3 = 0;
	int acar_u3 = 0;
	int acar_jr3 = 0;	//����
	int acar_sp3 = 0;	//����
	int acar_it3 = 0;
	int acar_exec3 = 0;	//�ӿ�(20180712)
	
	int acar_tot3 = 0;
	
	int acar_tot23 = 0;

// ���س�-2 �ܱ��� ������ ��Ȳ ����
	int acar_yk4 = 0; 
	int acar_y4 = 0; 
	int acar_k4 = 0;
	int acar_c4 = 0;
	int acar_b4 = 0;
	int acar_d4 = 0;
	int acar_s4 = 0;
	int acar_j4 = 0;
	int acar_g4 = 0;	
	int acar_i4 = 0;
	int acar_w4 = 0;
	int acar_gs4 = 0;
	int acar_gr4 = 0;
	int acar_u4 = 0;
	int acar_jr4 = 0;	//����
	int acar_sp4 = 0;	//����
	int acar_it4= 0;
	int acar_exec4 = 0;	//�ӿ�(20180712)
	
	int acar_tot4 = 0;

// ���س�-2 ������ ������ ��Ȳ ����
	int acar_yk5 = 0;
	int acar_y5 = 0;
	int acar_k5 = 0;
	int acar_c5 = 0;
	int acar_b5 = 0;
	int acar_d5 = 0;
	int acar_s5 = 0;
	int acar_j5 = 0;
	int acar_g5 = 0;	
	int acar_i5 = 0;
	int acar_w5 = 0;
	int acar_gs5 = 0;
	int acar_gr5 = 0;
	int acar_u5 = 0;
	int acar_jr5 = 0;	//����
	int acar_sp5 = 0;	//����
	int acar_it5 = 0;
	int acar_exec5 = 0;	//�ӿ�(20180712)
	
	int acar_tot5 = 0;
		
	int acar_tot45 = 0;

// ���س�-3 �ܱ��� ������ ��Ȳ ����
	int acar_yk6 = 0; 
	int acar_y6 = 0; 
	int acar_k6 = 0;
	int acar_c6 = 0;
	int acar_b6 = 0;
	int acar_d6 = 0;
	int acar_s6 = 0;
	int acar_j6 = 0;
	int acar_g6 = 0;	
	int acar_i6 = 0;
	int acar_w6 = 0;
	int acar_gs6 = 0;
	int acar_gr6 = 0;
	int acar_u6 = 0;
	int acar_jr6 = 0;	//����
	int acar_sp6 = 0;	//����
	int acar_it6 = 0;
	int acar_exec6 = 0;	//�ӿ�(20180712)
	
	int acar_tot6 = 0;

// ���س�-3 ������ ������ ��Ȳ ����
	int acar_yk7 = 0;
	int acar_y7 = 0;
	int acar_k7 = 0;
	int acar_c7 = 0;
	int acar_b7 = 0;
	int acar_d7 = 0;
	int acar_s7 = 0;
	int acar_j7 = 0;
	int acar_g7 = 0;	
	int acar_i7 = 0;	
	int acar_w7 = 0;	
	int acar_gs7 = 0;
	int acar_gr7 = 0;
	int acar_u7 = 0;
	int acar_jr7 = 0;	//����
	int acar_sp7 = 0;	//����
	int acar_it7 = 0;
	int acar_exec7 = 0;	//�ӿ�(20180712)
	
	int acar_tot7 = 0;
	
	int acar_tot67 = 0;

// ���س�-4 �ܱ��� ������ ��Ȳ ����
	int acar_yk8 = 0; 
	int acar_y8 = 0; 
	int acar_k8 = 0;
	int acar_c8 = 0;
	int acar_b8 = 0;
	int acar_d8 = 0;
	int acar_s8 = 0;
	int acar_j8 = 0;
	int acar_g8 = 0;	
	int acar_i8 = 0;	
	int acar_w8 = 0;	
	int acar_gs8 = 0;
	int acar_gr8 = 0;
	int acar_u8 = 0;
	int acar_jr8 = 0;	//����
	int acar_sp8 = 0;	//����
	int acar_it8 = 0;
	int acar_exec8 = 0;	//�ӿ�(20180712)
	
	int acar_tot8 = 0;

// ���س�-4 ������ ������ ��Ȳ ����
	int acar_yk9 = 0;
	int acar_y9 = 0;
	int acar_k9 = 0;
	int acar_c9 = 0;
	int acar_b9 = 0;
	int acar_d9 = 0;
	int acar_s9 = 0;
	int acar_j9 = 0;
	int acar_g9 = 0;
	int acar_i9 = 0;
	int acar_w9 = 0;
	int acar_gs9 = 0;
	int acar_gr9 = 0;
	int acar_u9 = 0;
	int acar_jr9 = 0;	//����
	int acar_sp9 = 0;	//����
	int acar_it9 = 0;
	int acar_exec9 = 0;	//�ӿ�(20180712)
	
	int acar_tot9 = 0;
	
	int acar_tot89 = 0;
	
// �μ��� ��Ȳ ����
	int acar_yk01 = 0;
	int acar_y01 = 0;
	int acar_k01 = 0;
	int acar_c01 = 0;
	int acar_it01 = 0;
	int acar_exec01 = 0;	//�ӿ�(20180712)
	
	int acar_tot_ygc01 = 0;
	
	int acar_b01 = 0;
	int acar_d01 = 0;
	int acar_s01 = 0;
	int acar_j01 = 0;
	int acar_g01 = 0;	
	int acar_i01 = 0;
	int acar_w01 = 0;
	int acar_gs01 = 0;
	int acar_gr01 = 0;
	int acar_u01 = 0;
	int acar_jr01 = 0;	//����
	int acar_sp01 = 0;	//����
	
	
	int acar_tot_bd01 = 0;

//2007�� �μ��� ��Ȳ ����
	int acar_yk23 = 0;
	int acar_y23 = 0;
	int acar_k23 = 0;
	int acar_c23 = 0;
	int acar_it23 = 0;
	int acar_exec23 = 0;	//�ӿ�(20180712)
	
	int acar_tot_ygc23 = 0;
	
	int acar_b23 = 0;
	int acar_d23 = 0;
	int acar_s23 = 0;
	int acar_j23 = 0;
	int acar_g23 = 0;
	int acar_i23 = 0;
	int acar_w23 = 0;
	int acar_gs23 = 0;
	int acar_gr23 = 0;
	int acar_u23 = 0;
	int acar_jr23 = 0;	//����
	int acar_sp23 = 0;	//����
	
	
	int acar_tot_bd23 = 0;

//2006�� �μ��� ��Ȳ ����
	int acar_yk45 = 0;
	int acar_y45 = 0;
	int acar_k45 = 0;
	int acar_c45 = 0;
	int acar_it45 = 0;
	int acar_exec45 = 0;	//�ӿ�(20180712)
	
	int acar_tot_ygc45 = 0;
	
	int acar_b45 = 0;
	int acar_d45 = 0;
	int acar_s45 = 0;
	int acar_j45 = 0;
	int acar_g45 = 0;
	int acar_i45 = 0;
	int acar_w45 = 0;
	int acar_gs45 = 0;
	int acar_gr45 = 0;
	int acar_u45 = 0;
	int acar_jr45 = 0;	//����
	int acar_sp45 = 0;	//����
	
	
	int acar_tot_bd45 = 0;

//2005�� �μ��� ��Ȳ ����	
	int acar_yk67 = 0;
	int acar_y67 = 0;
	int acar_k67 = 0;
	int acar_c67 = 0;
	int acar_it67 = 0;
	int acar_exec67 = 0;	//�ӿ�(20180712)
	
	int acar_tot_ygc67 = 0;
	
	int acar_b67 = 0;
	int acar_d67 = 0;
	int acar_s67 = 0;
	int acar_j67 = 0;
	int acar_g67 = 0;
	int acar_i67 = 0;
	int acar_w67 = 0;
	int acar_gs67 = 0;
	int acar_gr67 = 0;
	int acar_u67 = 0;
	int acar_jr67 = 0;	//����
	int acar_sp67 = 0;	//����
	
	
	int acar_tot_bd67 = 0;

//2004�� �μ��� ��Ȳ ����	
	int acar_yk89 = 0;
	int acar_y89 = 0;
	int acar_k89 = 0;
	int acar_c89 = 0;
	int acar_it89 = 0;
	int acar_exec89 = 0;	//�ӿ�(20180712)
	
	int acar_tot_ygc89 = 0;
	
	int acar_b89 = 0;
	int acar_d89 = 0;
	int acar_s89 = 0;
	int acar_j89 = 0;
	int acar_g89 = 0;
	int acar_i89 = 0;
	int acar_w89 = 0;
	int acar_gs89 = 0;
	int acar_gr89 = 0;
	int acar_u89 = 0;
	int acar_jr89 = 0;	//����
	int acar_sp89 = 0;	//����
	
	
	int acar_tot_bd89 = 0;
	
	int start_year = Util.parseInt(request.getParameter("start_year"));
	int nyear = 0;
	if(start_year==0)
	{
		nyear = calendar.getThisYear();
	}else{
		nyear = start_year;
	}
	
	int thisyear = Util.parseInt(nyear+"1231");
	int thisyear1 = Util.parseInt((nyear-1)+"1231");
	int thisyear2 = Util.parseInt((nyear-2)+"1231");
	int thisyear3 = Util.parseInt((nyear-3)+"1231");
	int thisyear4 = Util.parseInt((nyear-4)+"1231");
	
	int ty = Util.parseInt(nyear+"0101");
	int ty1 = Util.parseInt((nyear-1)+"0101");
	int ty2 = Util.parseInt((nyear-2)+"0101");
	int ty3 = Util.parseInt((nyear-3)+"0101");
	int ty4 = Util.parseInt((nyear-4)+"0101");
	
	
	Vector vt = ic_db.gylist_yeardate(user_id, auth_rw, s_kd, t_wd, sort_gubun, asc, thisyear, ty);
	int vt_size = vt.size();
	
	Vector vt1 = ic_db.gylist_yeardate(user_id, auth_rw, s_kd, t_wd, sort_gubun, asc, thisyear1, ty1);
	int vt1_size = vt1.size();
	
	Vector vt2 = ic_db.gylist_yeardate(user_id, auth_rw, s_kd, t_wd, sort_gubun, asc, thisyear2, ty2);
	int vt2_size = vt2.size();
	
	Vector vt3 = ic_db.gylist_yeardate(user_id, auth_rw, s_kd, t_wd, sort_gubun, asc, thisyear3, ty3);
	int vt3_size = vt3.size();
	
	Vector vt4 = ic_db.gylist_yeardate(user_id, auth_rw, s_kd, t_wd, sort_gubun, asc, thisyear4, ty4);
	int vt4_size = vt4.size();
	
/*	
System.out.println(thisyear);
System.out.println(thisyear1);
System.out.println(thisyear2);
System.out.println(thisyear3);
System.out.println(thisyear4);
*/
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">

<!--

//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
<%	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
// ���س�----------------------------------------------------------------------------------------------------------------	
		if(ht.get("DEPT_ID").equals("0001") && (ht.get("LOAN_ST").equals("1") || ht.get("LOAN_ST").equals("2")) )	{
		
		acar_y0++;
		}else if(ht.get("DEPT_ID").equals("0020") && (ht.get("LOAN_ST").equals("1") || ht.get("LOAN_ST").equals("2")) )	{
		acar_yk0++;
		}else if(ht.get("DEPT_ID").equals("0002") && (ht.get("LOAN_ST").equals("1") || ht.get("LOAN_ST").equals("2")) )	{
		acar_k0++;
		}else if(ht.get("DEPT_ID").equals("0003") && (ht.get("LOAN_ST").equals("1") || ht.get("LOAN_ST").equals("2")) )	{
		acar_c0++;
		}else if(ht.get("DEPT_ID").equals("0007") && (ht.get("LOAN_ST").equals("1") || ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("3")) )	{
		acar_b0++;
		}else if(ht.get("DEPT_ID").equals("0008") && (ht.get("LOAN_ST").equals("1") || ht.get("LOAN_ST").equals("2")) )	{
		acar_d0++;
		}else if(ht.get("DEPT_ID").equals("0009") && (ht.get("LOAN_ST").equals("1") || ht.get("LOAN_ST").equals("2")) )	{
		acar_s0++;
		}else if(ht.get("DEPT_ID").equals("0010") && (ht.get("LOAN_ST").equals("1") || ht.get("LOAN_ST").equals("2")) )	{
		acar_j0++;
		}else if(ht.get("DEPT_ID").equals("0011") && (ht.get("LOAN_ST").equals("1") || ht.get("LOAN_ST").equals("2")) )	{
		acar_g0++;
		}else if(ht.get("DEPT_ID").equals("0012") && (ht.get("LOAN_ST").equals("1") || ht.get("LOAN_ST").equals("2")) )	{
		acar_i0++;
		}else if(ht.get("DEPT_ID").equals("0013") && (ht.get("LOAN_ST").equals("1") || ht.get("LOAN_ST").equals("2")) )	{
		acar_w0++;
		}else if(ht.get("DEPT_ID").equals("0014") && (ht.get("LOAN_ST").equals("1") || ht.get("LOAN_ST").equals("2")) )	{
		acar_gs0++;
		}else if(ht.get("DEPT_ID").equals("0015") && (ht.get("LOAN_ST").equals("1") || ht.get("LOAN_ST").equals("2")) )	{
		acar_gr0++;
		}else if(ht.get("DEPT_ID").equals("0016") && (ht.get("LOAN_ST").equals("1") || ht.get("LOAN_ST").equals("2")) )	{
		acar_u0++;
		}else if(ht.get("DEPT_ID").equals("0017") && (ht.get("LOAN_ST").equals("1") || ht.get("LOAN_ST").equals("2")) )	{
		acar_jr0++;
		}else if(ht.get("DEPT_ID").equals("0018") && (ht.get("LOAN_ST").equals("1") || ht.get("LOAN_ST").equals("2")) )	{
		acar_sp0++;
		}else if(ht.get("DEPT_ID").equals("0005") && (ht.get("LOAN_ST").equals("1") || ht.get("LOAN_ST").equals("2")) )	{
		acar_it0++;
		//�ӿ�(2018.07.12)
		}else if(ht.get("DEPT_ID").equals("0004") && (ht.get("LOAN_ST").equals("1") || ht.get("LOAN_ST").equals("2")) )	{
		acar_exec0++;
		}
		
		acar_tot0 = acar_yk0 + acar_y0 + acar_k0 + acar_c0 + acar_b0 + acar_d0 + acar_s0 + acar_j0 + acar_g0 + acar_i0 + acar_w0 + acar_gs0 + acar_gr0 + acar_u0 + acar_jr0 + acar_sp0 + acar_it0 + acar_exec0;
		
		if(ht.get("DEPT_ID").equals("0001") && ht.get("LOAN_ST").equals(""))	{
		acar_y1++;
		}else if(ht.get("DEPT_ID").equals("0020") && ht.get("LOAN_ST").equals(""))	{
			if (ht.get("USER_POS").equals("�̻�")) {
				acar_exec1++;
			} else {
				acar_yk1++;
			}
		}else if(ht.get("DEPT_ID").equals("0002") && ht.get("LOAN_ST").equals(""))	{
		acar_k1++;
		}else if(ht.get("DEPT_ID").equals("0003") && ht.get("LOAN_ST").equals(""))	{
			if (ht.get("USER_POS").equals("�̻�")) {
				acar_exec1++;
			} else {
				acar_c1++;
			}
		}else if(ht.get("DEPT_ID").equals("0007") && ht.get("LOAN_ST").equals(""))	{
		acar_b1++;
		}else if(ht.get("DEPT_ID").equals("0008") && ht.get("LOAN_ST").equals(""))	{
		acar_d1++;
		}else if(ht.get("DEPT_ID").equals("0009") && ht.get("LOAN_ST").equals(""))	{
		acar_s1++;
		}else if(ht.get("DEPT_ID").equals("0010") && ht.get("LOAN_ST").equals(""))	{
		acar_j1++;
		}else if(ht.get("DEPT_ID").equals("0011") && ht.get("LOAN_ST").equals(""))	{
		acar_g1++;
		}else if(ht.get("DEPT_ID").equals("0012") && ht.get("LOAN_ST").equals(""))	{
		acar_i1++;
		}else if(ht.get("DEPT_ID").equals("0013") && ht.get("LOAN_ST").equals(""))	{
		acar_w1++;
		}else if(ht.get("DEPT_ID").equals("0014") && ht.get("LOAN_ST").equals(""))	{
		acar_gs1++;
		}else if(ht.get("DEPT_ID").equals("0015") && ht.get("LOAN_ST").equals(""))	{
		acar_gr1++;
		}else if(ht.get("DEPT_ID").equals("0016") && ht.get("LOAN_ST").equals(""))	{
		acar_u1++;
		}else if(ht.get("DEPT_ID").equals("0017") && ht.get("LOAN_ST").equals(""))	{
		acar_jr1++;
		}else if(ht.get("DEPT_ID").equals("0018") && ht.get("LOAN_ST").equals(""))	{
		acar_sp1++;
		}else if(ht.get("DEPT_ID").equals("0005") && ht.get("LOAN_ST").equals(""))	{
		acar_it1++;
		//�ӿ�(2018.07.12)
		}else if(ht.get("DEPT_ID").equals("0004") && ht.get("LOAN_ST").equals(""))	{
		acar_exec1++;
		}		
		acar_tot1 = acar_yk1 + acar_y1 + acar_k1 + acar_c1 + acar_b1 + acar_d1 + acar_s1 + acar_j1 + acar_g1 + acar_i1 + acar_w1 + acar_gs1 + acar_gr1 + acar_u1 + acar_jr1 + acar_sp1 + acar_it1 + acar_exec1;
		
		acar_tot01 = acar_tot0 + acar_tot1;
}
%>
<%	for(int j = 0 ; j < vt1_size ; j++){
		Hashtable ht1 = (Hashtable)vt1.elementAt(j);
// ���س� - 1 ----------------------------------------------------------------------------------------------	
	
		if( ht1.get("DEPT_ID").equals("0001") && (ht1.get("LOAN_ST").equals("1") || ht1.get("LOAN_ST").equals("2")) )	{
		acar_y2++;
		}else if( ht1.get("DEPT_ID").equals("0020") && (ht1.get("LOAN_ST").equals("1") || ht1.get("LOAN_ST").equals("2")) )	{
		acar_yk2++;
		}else if( ht1.get("DEPT_ID").equals("0002") && (ht1.get("LOAN_ST").equals("1") || ht1.get("LOAN_ST").equals("2")) )	{
		acar_k2++;
		}else if( ht1.get("DEPT_ID").equals("0003") && (ht1.get("LOAN_ST").equals("1") || ht1.get("LOAN_ST").equals("2")) )	{
		acar_c2++;
		}else if( ht1.get("DEPT_ID").equals("0007") && (ht1.get("LOAN_ST").equals("1") || ht1.get("LOAN_ST").equals("2") || ht1.get("LOAN_ST").equals("3")) )	{
		acar_b2++;
		}else if( ht1.get("DEPT_ID").equals("0008") && (ht1.get("LOAN_ST").equals("1") || ht1.get("LOAN_ST").equals("2")) )	{
		acar_d2++;
		}else if( ht1.get("DEPT_ID").equals("0009") && (ht1.get("LOAN_ST").equals("1") || ht1.get("LOAN_ST").equals("2")) )	{
		acar_s2++;
		}else if( ht1.get("DEPT_ID").equals("0010") && (ht1.get("LOAN_ST").equals("1") || ht1.get("LOAN_ST").equals("2")) )	{
		acar_j2++;
		}else if( ht1.get("DEPT_ID").equals("0011") && (ht1.get("LOAN_ST").equals("1") || ht1.get("LOAN_ST").equals("2")) )	{
		acar_g2++;
		}else if( ht1.get("DEPT_ID").equals("0012") && (ht1.get("LOAN_ST").equals("1") || ht1.get("LOAN_ST").equals("2")) )	{
		acar_i2++;
		}else if( ht1.get("DEPT_ID").equals("0013") && (ht1.get("LOAN_ST").equals("1") || ht1.get("LOAN_ST").equals("2")) )	{
		acar_w2++;
		}else if( ht1.get("DEPT_ID").equals("0014") && (ht1.get("LOAN_ST").equals("1") || ht1.get("LOAN_ST").equals("2")) )	{
		acar_gs2++;
		}else if( ht1.get("DEPT_ID").equals("0015") && (ht1.get("LOAN_ST").equals("1") || ht1.get("LOAN_ST").equals("2")) )	{
		acar_gr2++;
		}else if( ht1.get("DEPT_ID").equals("0016") && (ht1.get("LOAN_ST").equals("1") || ht1.get("LOAN_ST").equals("2")) )	{
		acar_u2++;
		}else if( ht1.get("DEPT_ID").equals("0017") && (ht1.get("LOAN_ST").equals("1") || ht1.get("LOAN_ST").equals("2")) )	{
		acar_jr2++;
		}else if( ht1.get("DEPT_ID").equals("0018") && (ht1.get("LOAN_ST").equals("1") || ht1.get("LOAN_ST").equals("2")) )	{
		acar_sp2++;
		}else if( ht1.get("DEPT_ID").equals("0005") && (ht1.get("LOAN_ST").equals("1") || ht1.get("LOAN_ST").equals("2")) )	{
		acar_it2++;
		//�ӿ�(20180712)
		}else if( ht1.get("DEPT_ID").equals("0004") && (ht1.get("LOAN_ST").equals("1") || ht1.get("LOAN_ST").equals("2")) )	{
		acar_exec2++;
		} 
		acar_tot2 = acar_yk2 + acar_y2 + acar_k2 + acar_c2 + acar_b2 + acar_d2 + acar_s2 + acar_j2 + acar_g2 + acar_i2 + acar_w2 + acar_gs2 + acar_gr2 + acar_u2 + acar_jr2 + acar_sp2 + acar_it2 + acar_exec2;
		
		if( ht1.get("DEPT_ID").equals("0001") && ht1.get("LOAN_ST").equals(""))	{
		acar_y3++;
		}else if( ht1.get("DEPT_ID").equals("0020") && ht1.get("LOAN_ST").equals(""))	{
			if (ht1.get("USER_POS").equals("�̻�")) {
				acar_exec3++;
			} else {
				acar_yk3++;
			}
		}else if( ht1.get("DEPT_ID").equals("0002") && ht1.get("LOAN_ST").equals(""))	{
		acar_k3++;
		}else if( ht1.get("DEPT_ID").equals("0003") && ht1.get("LOAN_ST").equals(""))	{
			if (ht1.get("USER_POS").equals("�̻�")) {
				acar_exec3++;
			} else {
				acar_c3++;		
			}
		}else if( ht1.get("DEPT_ID").equals("0007") && ht1.get("LOAN_ST").equals(""))	{
		acar_b3++;
		}else if( ht1.get("DEPT_ID").equals("0008") && ht1.get("LOAN_ST").equals(""))	{
		acar_d3++;
		}else if( ht1.get("DEPT_ID").equals("0009") && ht1.get("LOAN_ST").equals(""))	{
		acar_s3++;
		}else if( ht1.get("DEPT_ID").equals("0010") && ht1.get("LOAN_ST").equals(""))	{
		acar_j3++;
		}else if( ht1.get("DEPT_ID").equals("0011") && ht1.get("LOAN_ST").equals(""))	{
		acar_g3++;
		}else if( ht1.get("DEPT_ID").equals("0012") && ht1.get("LOAN_ST").equals(""))	{
		acar_i3++;
		}else if( ht1.get("DEPT_ID").equals("0013") && ht1.get("LOAN_ST").equals(""))	{
		acar_w3++;
		}else if( ht1.get("DEPT_ID").equals("0014") && ht1.get("LOAN_ST").equals(""))	{
		acar_gs3++;
		}else if( ht1.get("DEPT_ID").equals("0015") && ht1.get("LOAN_ST").equals(""))	{
		acar_gr3++;
		}else if( ht1.get("DEPT_ID").equals("0016") && ht1.get("LOAN_ST").equals(""))	{
		acar_u3++;
		}else if( ht1.get("DEPT_ID").equals("0017") && ht1.get("LOAN_ST").equals(""))	{
		acar_jr3++;
		}else if( ht1.get("DEPT_ID").equals("0018") && ht1.get("LOAN_ST").equals(""))	{
		acar_sp3++;
		}else if( ht1.get("DEPT_ID").equals("0005") && ht1.get("LOAN_ST").equals(""))	{
		acar_it3++;
		}else if( ht1.get("DEPT_ID").equals("0004") && ht1.get("LOAN_ST").equals(""))	{
		acar_exec3++;
		} 
		acar_tot3 = acar_yk3 + acar_y3 + acar_k3 + acar_c3 + acar_b3 + acar_d3 + acar_s3 + acar_j3 + acar_g3 + acar_i3 + acar_w3 + acar_gs3 + acar_gr3 + acar_u3 + acar_jr3 + acar_sp3 + acar_it3 + acar_exec3;
		
		acar_tot23 = acar_tot2 + acar_tot3 ;
}
%>
<%	for(int k = 0 ; k < vt2_size ; k++){
		Hashtable ht2 = (Hashtable)vt2.elementAt(k);
// ���س� -2 ----------------------------------------------------------------------------------------------	
	
		if( ht2.get("DEPT_ID").equals("0001") && (ht2.get("LOAN_ST").equals("1") || ht2.get("LOAN_ST").equals("2")) )	{
		acar_y4++;
		}else if( ht2.get("DEPT_ID").equals("0020") && (ht2.get("LOAN_ST").equals("1") || ht2.get("LOAN_ST").equals("2")) )	{
		acar_yk4++;
		}else if( ht2.get("DEPT_ID").equals("0002") && (ht2.get("LOAN_ST").equals("1") || ht2.get("LOAN_ST").equals("2")) )	{
		acar_k4++;
		}else if( ht2.get("DEPT_ID").equals("0003") && (ht2.get("LOAN_ST").equals("1") || ht2.get("LOAN_ST").equals("2")) )	{
		acar_c4++;
		}else if( ht2.get("DEPT_ID").equals("0007") && (ht2.get("LOAN_ST").equals("1") || ht2.get("LOAN_ST").equals("2") || ht2.get("LOAN_ST").equals("3")) )	{
		acar_b4++;
		}else if( ht2.get("DEPT_ID").equals("0008") && (ht2.get("LOAN_ST").equals("1") || ht2.get("LOAN_ST").equals("2")) )	{
		acar_d4++;
		}else if( ht2.get("DEPT_ID").equals("0009") && (ht2.get("LOAN_ST").equals("1") || ht2.get("LOAN_ST").equals("2")) )	{
		acar_s4++;
		}else if( ht2.get("DEPT_ID").equals("0010") && (ht2.get("LOAN_ST").equals("1") || ht2.get("LOAN_ST").equals("2")) )	{
		acar_j4++;
		}else if( ht2.get("DEPT_ID").equals("0011") && (ht2.get("LOAN_ST").equals("1") || ht2.get("LOAN_ST").equals("2")) )	{
		acar_g4++;
		}else if( ht2.get("DEPT_ID").equals("0012") && (ht2.get("LOAN_ST").equals("1") || ht2.get("LOAN_ST").equals("2")) )	{
		acar_i4++;
		}else if( ht2.get("DEPT_ID").equals("0013") && (ht2.get("LOAN_ST").equals("1") || ht2.get("LOAN_ST").equals("2")) )	{
		acar_w4++;
		}else if( ht2.get("DEPT_ID").equals("0014") && (ht2.get("LOAN_ST").equals("1") || ht2.get("LOAN_ST").equals("2")) )	{
		acar_gs4++;
		}else if( ht2.get("DEPT_ID").equals("0015") && (ht2.get("LOAN_ST").equals("1") || ht2.get("LOAN_ST").equals("2")) )	{
		acar_gr4++;
		}else if( ht2.get("DEPT_ID").equals("0016") && (ht2.get("LOAN_ST").equals("1") || ht2.get("LOAN_ST").equals("2")) )	{
		acar_u4++;
		}else if( ht2.get("DEPT_ID").equals("0017") && (ht2.get("LOAN_ST").equals("1") || ht2.get("LOAN_ST").equals("2")) )	{
		acar_jr4++;
		}else if( ht2.get("DEPT_ID").equals("0018") && (ht2.get("LOAN_ST").equals("1") || ht2.get("LOAN_ST").equals("2")) )	{
		acar_sp4++;
		}else if( ht2.get("DEPT_ID").equals("0005") && (ht2.get("LOAN_ST").equals("1") || ht2.get("LOAN_ST").equals("2")) )	{
		acar_it4++;
		//�ӿ�(20180712)
		}else if( ht2.get("DEPT_ID").equals("0004") && (ht2.get("LOAN_ST").equals("1") || ht2.get("LOAN_ST").equals("2")) )	{
		acar_exec4++;
		} 
		acar_tot4 = acar_yk4 + acar_y4 + acar_k4 + acar_c4 + acar_b4 + acar_d4 + acar_s4 + acar_j4 + acar_g4 + acar_i4 + acar_w4 + acar_gs4 + acar_gr4 + acar_u4 + acar_jr4 + acar_sp4 + acar_it4 + acar_exec4;
		
		if( ht2.get("DEPT_ID").equals("0001") && ht2.get("LOAN_ST").equals(""))	{
		acar_y5++;
		}else if( ht2.get("DEPT_ID").equals("0020") && ht2.get("LOAN_ST").equals(""))	{
			if (ht2.get("USER_POS").equals("�̻�")) {
				acar_exec5++;
			} else {
				acar_yk5++;				
			}
		}else if( ht2.get("DEPT_ID").equals("0002") && ht2.get("LOAN_ST").equals(""))	{
		acar_k5++;
		}else if( ht2.get("DEPT_ID").equals("0003") && ht2.get("LOAN_ST").equals(""))	{
			if (ht2.get("USER_POS").equals("�̻�")) {
				acar_exec5++;
			} else {
				acar_c5++;
			}
		}else if( ht2.get("DEPT_ID").equals("0007") && ht2.get("LOAN_ST").equals(""))	{
		acar_b5++;
		}else if( ht2.get("DEPT_ID").equals("0008") && ht2.get("LOAN_ST").equals(""))	{
		acar_d5++;
		}else if( ht2.get("DEPT_ID").equals("0009") && ht2.get("LOAN_ST").equals(""))	{
		acar_s5++;
		}else if( ht2.get("DEPT_ID").equals("0010") && ht2.get("LOAN_ST").equals(""))	{
		acar_j5++;
		}else if( ht2.get("DEPT_ID").equals("0011") && ht2.get("LOAN_ST").equals(""))	{
		acar_g5++;
		}else if( ht2.get("DEPT_ID").equals("0012") && ht2.get("LOAN_ST").equals(""))	{
		acar_i5++;
		}else if( ht2.get("DEPT_ID").equals("0013") && ht2.get("LOAN_ST").equals(""))	{
		acar_w5++;
		}else if( ht2.get("DEPT_ID").equals("0014") && ht2.get("LOAN_ST").equals(""))	{
		acar_gs5++;
		}else if( ht2.get("DEPT_ID").equals("0015") && ht2.get("LOAN_ST").equals(""))	{
		acar_gr5++;
		}else if( ht2.get("DEPT_ID").equals("0016") && ht2.get("LOAN_ST").equals(""))	{
		acar_u5++;
		}else if( ht2.get("DEPT_ID").equals("0017") && ht2.get("LOAN_ST").equals(""))	{
		acar_jr5++;
		}else if( ht2.get("DEPT_ID").equals("0018") && ht2.get("LOAN_ST").equals(""))	{
		acar_sp5++;
		}else if( ht2.get("DEPT_ID").equals("0005") && ht2.get("LOAN_ST").equals(""))	{
		acar_it5++;
		//�ӿ�(20180712)
		}else if( ht2.get("DEPT_ID").equals("0004") && ht2.get("LOAN_ST").equals(""))	{
		acar_exec5++;
		}
		
		acar_tot5 = acar_yk5 + acar_y5 + acar_k5 + acar_c5 + acar_b5 + acar_d5 + acar_s5 + acar_j5 + acar_g5 + acar_i5 + acar_w5 + acar_gs5 + acar_gr5 + acar_u5 + acar_jr5 + acar_sp5 + acar_it5 + acar_exec5;
		
		acar_tot45 = acar_tot4 + acar_tot5 ;
}
%>
<%	for(int l = 0 ; l < vt3_size ; l++){
		Hashtable ht3 = (Hashtable)vt3.elementAt(l);
// ���س� - 3 ----------------------------------------------------------------------------------------------	
	
		if( ht3.get("DEPT_ID").equals("0001") && (ht3.get("LOAN_ST").equals("1") || ht3.get("LOAN_ST").equals("2")) )	{
		acar_y6++;
		}else if( ht3.get("DEPT_ID").equals("0020") && (ht3.get("LOAN_ST").equals("1") || ht3.get("LOAN_ST").equals("2")) )	{
		acar_yk6++;
		}else if( ht3.get("DEPT_ID").equals("0002") && (ht3.get("LOAN_ST").equals("1") || ht3.get("LOAN_ST").equals("2")) )	{
		acar_k6++;
		}else if( ht3.get("DEPT_ID").equals("0003") && (ht3.get("LOAN_ST").equals("1") || ht3.get("LOAN_ST").equals("2")) )	{
		acar_c6++;
		}else if( ht3.get("DEPT_ID").equals("0007") && (ht3.get("LOAN_ST").equals("1") || ht3.get("LOAN_ST").equals("2") || ht3.get("LOAN_ST").equals("3")) )	{
		acar_b6++;
		}else if( ht3.get("DEPT_ID").equals("0008") && (ht3.get("LOAN_ST").equals("1") || ht3.get("LOAN_ST").equals("2")) )	{
		acar_d6++;
		}else if( ht3.get("DEPT_ID").equals("0009") && (ht3.get("LOAN_ST").equals("1") || ht3.get("LOAN_ST").equals("2")) )	{
		acar_s6++;
		}else if( ht3.get("DEPT_ID").equals("0010") && (ht3.get("LOAN_ST").equals("1") || ht3.get("LOAN_ST").equals("2")) )	{
		acar_j6++;
		}else if( ht3.get("DEPT_ID").equals("0011") && (ht3.get("LOAN_ST").equals("1") || ht3.get("LOAN_ST").equals("2")) )	{
		acar_g6++;
		}else if( ht3.get("DEPT_ID").equals("0012") && (ht3.get("LOAN_ST").equals("1") || ht3.get("LOAN_ST").equals("2")) )	{
		acar_i6++;
		}else if( ht3.get("DEPT_ID").equals("0013") && (ht3.get("LOAN_ST").equals("1") || ht3.get("LOAN_ST").equals("2")) )	{
		acar_w6++;
		}else if( ht3.get("DEPT_ID").equals("0014") && (ht3.get("LOAN_ST").equals("1") || ht3.get("LOAN_ST").equals("2")) )	{
		acar_gs6++;
		}else if( ht3.get("DEPT_ID").equals("0015") && (ht3.get("LOAN_ST").equals("1") || ht3.get("LOAN_ST").equals("2")) )	{
		acar_gr6++;
		}else if( ht3.get("DEPT_ID").equals("0016") && (ht3.get("LOAN_ST").equals("1") || ht3.get("LOAN_ST").equals("2")) )	{
		acar_u6++;
		}else if( ht3.get("DEPT_ID").equals("0017") && (ht3.get("LOAN_ST").equals("1") || ht3.get("LOAN_ST").equals("2")) )	{
		acar_jr6++;
		}else if( ht3.get("DEPT_ID").equals("0018") && (ht3.get("LOAN_ST").equals("1") || ht3.get("LOAN_ST").equals("2")) )	{
		acar_sp6++;
		}else if( ht3.get("DEPT_ID").equals("0005") && (ht3.get("LOAN_ST").equals("1") || ht3.get("LOAN_ST").equals("2")) )	{
		acar_it6++;
		//�ӿ�(20180712)
		}else if( ht3.get("DEPT_ID").equals("0004") && (ht3.get("LOAN_ST").equals("1") || ht3.get("LOAN_ST").equals("2")) )	{
		acar_exec6++;
		} 
		acar_tot6 = acar_yk6 + acar_y6 + acar_k6 + acar_c6 + acar_b6 + acar_d6 + acar_s6 + acar_j6 + acar_g6 + acar_i6 + acar_w6 + acar_gs6 + acar_gr6 + acar_u6 + acar_jr6 + acar_sp6 + acar_it6 + acar_exec6;
		
		if( ht3.get("DEPT_ID").equals("0001") && ht3.get("LOAN_ST").equals(""))	{
		acar_y7++;
		}else if( ht3.get("DEPT_ID").equals("0020") && ht3.get("LOAN_ST").equals(""))	{
			if (ht3.get("USER_POS").equals("�̻�")) {
				acar_exec7++;
			} else {
				acar_yk7++;
			}
		}else if( ht3.get("DEPT_ID").equals("0002") && ht3.get("LOAN_ST").equals(""))	{
		acar_k7++;
		}else if( ht3.get("DEPT_ID").equals("0003") && ht3.get("LOAN_ST").equals(""))	{
			if (ht3.get("USER_POS").equals("�̻�")) {
				acar_exec7++;
			} else {
				acar_c7++;
			}
		}else if( ht3.get("DEPT_ID").equals("0007") && ht3.get("LOAN_ST").equals(""))	{
		acar_b7++;
		}else if( ht3.get("DEPT_ID").equals("0008") && ht3.get("LOAN_ST").equals(""))	{
		acar_d7++;
		}else if( ht3.get("DEPT_ID").equals("0009") && ht3.get("LOAN_ST").equals(""))	{
		acar_s7++;
		}else if( ht3.get("DEPT_ID").equals("0010") && ht3.get("LOAN_ST").equals(""))	{
		acar_j7++;
		}else if( ht3.get("DEPT_ID").equals("0011") && ht3.get("LOAN_ST").equals(""))	{
		acar_g7++;
		}else if( ht3.get("DEPT_ID").equals("0012") && ht3.get("LOAN_ST").equals(""))	{
		acar_i7++;
		}else if( ht3.get("DEPT_ID").equals("0013") && ht3.get("LOAN_ST").equals(""))	{
		acar_w7++;
		}else if( ht3.get("DEPT_ID").equals("0014") && ht3.get("LOAN_ST").equals(""))	{
		acar_gs7++;
		}else if( ht3.get("DEPT_ID").equals("0015") && ht3.get("LOAN_ST").equals(""))	{
		acar_gr7++;
		}else if( ht3.get("DEPT_ID").equals("0016") && ht3.get("LOAN_ST").equals(""))	{
		acar_u7++;
		}else if( ht3.get("DEPT_ID").equals("0017") && ht3.get("LOAN_ST").equals(""))	{
		acar_jr7++;
		}else if( ht3.get("DEPT_ID").equals("0018") && ht3.get("LOAN_ST").equals(""))	{
		acar_sp7++;
		}else if( ht3.get("DEPT_ID").equals("0005") && ht3.get("LOAN_ST").equals(""))	{
		acar_it7++;
		//�ӿ�(20180712)
		}else if( ht3.get("DEPT_ID").equals("0004") && ht3.get("LOAN_ST").equals(""))	{
		acar_exec7++;
		}
		
		acar_tot7 = acar_yk7 + acar_y7 + acar_k7 + acar_c7 + acar_b7 + acar_d7 + acar_s7 + acar_j7 + acar_g7 + acar_i7 + acar_w7 + acar_gs7 + acar_gr7 + acar_u7 + acar_jr7 + acar_sp7 + acar_it7 + acar_exec7;
		
		acar_tot67 = acar_tot6 + acar_tot7 ;
}
%>
<%	for(int m = 0 ; m < vt4_size ; m++){
		Hashtable ht4 = (Hashtable)vt4.elementAt(m);
// ���س� -4 ----------------------------------------------------------------------------------------------	
	
		if(ht4.get("DEPT_ID").equals("0001") && (ht4.get("LOAN_ST").equals("1") || ht4.get("LOAN_ST").equals("2")) )	{
			//out.println(ht4.get("USER_NM"));
		acar_y8++;
		}else if( ht4.get("DEPT_ID").equals("0020") && (ht4.get("LOAN_ST").equals("1") || ht4.get("LOAN_ST").equals("2")) )	{
		acar_yk8++;
		}else if( ht4.get("DEPT_ID").equals("0002") && (ht4.get("LOAN_ST").equals("1") || ht4.get("LOAN_ST").equals("2")) )	{
		acar_k8++;
		}else if( ht4.get("DEPT_ID").equals("0003") && (ht4.get("LOAN_ST").equals("1") || ht4.get("LOAN_ST").equals("2")) )	{
		acar_c8++;
		}else if( ht4.get("DEPT_ID").equals("0007") && (ht4.get("LOAN_ST").equals("1") || ht4.get("LOAN_ST").equals("2") || ht4.get("LOAN_ST").equals("3")) )	{
		acar_b8++;
		}else if( ht4.get("DEPT_ID").equals("0008") && (ht4.get("LOAN_ST").equals("1") || ht4.get("LOAN_ST").equals("2")) )	{
		acar_d8++;
		}else if( ht4.get("DEPT_ID").equals("0009") && (ht4.get("LOAN_ST").equals("1") || ht4.get("LOAN_ST").equals("2")) )	{
		acar_s8++;
		}else if( ht4.get("DEPT_ID").equals("0010") && (ht4.get("LOAN_ST").equals("1") || ht4.get("LOAN_ST").equals("2")) )	{
		acar_j8++;
		}else if( ht4.get("DEPT_ID").equals("0011") && (ht4.get("LOAN_ST").equals("1") || ht4.get("LOAN_ST").equals("2")) )	{
		acar_g8++;
		}else if( ht4.get("DEPT_ID").equals("0012") && (ht4.get("LOAN_ST").equals("1") || ht4.get("LOAN_ST").equals("2")) )	{
		acar_i8++;
		}else if( ht4.get("DEPT_ID").equals("0013") && (ht4.get("LOAN_ST").equals("1") || ht4.get("LOAN_ST").equals("2")) )	{
		acar_w8++;
		}else if( ht4.get("DEPT_ID").equals("0014") && (ht4.get("LOAN_ST").equals("1") || ht4.get("LOAN_ST").equals("2")) )	{
		acar_gs8++;
		}else if( ht4.get("DEPT_ID").equals("0015") && (ht4.get("LOAN_ST").equals("1") || ht4.get("LOAN_ST").equals("2")) )	{
		acar_gr8++;
		}else if( ht4.get("DEPT_ID").equals("0016") && (ht4.get("LOAN_ST").equals("1") || ht4.get("LOAN_ST").equals("2")) )	{
		acar_u8++;
		}else if( ht4.get("DEPT_ID").equals("0017") && (ht4.get("LOAN_ST").equals("1") || ht4.get("LOAN_ST").equals("2")) )	{
		acar_jr8++;
		}else if( ht4.get("DEPT_ID").equals("0018") && (ht4.get("LOAN_ST").equals("1") || ht4.get("LOAN_ST").equals("2")) )	{
		acar_sp8++;
		}else if( ht4.get("DEPT_ID").equals("0005") && (ht4.get("LOAN_ST").equals("1") || ht4.get("LOAN_ST").equals("2")) )	{
		acar_it8++;
		//�ӿ�(20180712)
		}else if( ht4.get("DEPT_ID").equals("0004") && (ht4.get("LOAN_ST").equals("1") || ht4.get("LOAN_ST").equals("2")) )	{
		acar_exec8++;
		}

		acar_tot8 = acar_yk8 + acar_y8 + acar_k8 + acar_c8 + acar_b8 + acar_d8 + acar_s8 + acar_j8 + acar_g8 + acar_i8 + acar_w8 + acar_gs8 + acar_gr8 + acar_u8 + acar_jr8 + acar_sp8 + acar_it8 + acar_exec8;
		
		if( ht4.get("DEPT_ID").equals("0001") && ht4.get("LOAN_ST").equals(""))	{
		acar_y9++;
		}else if( ht4.get("DEPT_ID").equals("0020") && ht4.get("LOAN_ST").equals(""))	{		
			if (ht4.get("USER_POS").equals("�̻�")) {
				acar_exec9++;
			} else {
				acar_yk9++;
			}
		}else if( ht4.get("DEPT_ID").equals("0002") && ht4.get("LOAN_ST").equals(""))	{
		acar_k9++;
		}else if( ht4.get("DEPT_ID").equals("0003") && ht4.get("LOAN_ST").equals(""))	{				
			if (ht4.get("USER_POS").equals("�̻�")) {
				acar_exec9++;
			} else {
				acar_c9++;				
			}
		}else if( ht4.get("DEPT_ID").equals("0007") && ht4.get("LOAN_ST").equals(""))	{
		acar_b9++;
		}else if( ht4.get("DEPT_ID").equals("0008") && ht4.get("LOAN_ST").equals(""))	{
		acar_d9++;
		}else if( ht4.get("DEPT_ID").equals("0009") && ht4.get("LOAN_ST").equals(""))	{
		acar_s9++;
		}else if( ht4.get("DEPT_ID").equals("0010") && ht4.get("LOAN_ST").equals(""))	{
		acar_j9++;
		}else if( ht4.get("DEPT_ID").equals("0011") && ht4.get("LOAN_ST").equals(""))	{
		acar_g9++;
		}else if( ht4.get("DEPT_ID").equals("0012") && ht4.get("LOAN_ST").equals(""))	{
		acar_i9++;
		}else if( ht4.get("DEPT_ID").equals("0013") && ht4.get("LOAN_ST").equals(""))	{
		acar_w9++;
		}else if( ht4.get("DEPT_ID").equals("0014") && ht4.get("LOAN_ST").equals(""))	{
		acar_gs9++;
		}else if( ht4.get("DEPT_ID").equals("0015") && ht4.get("LOAN_ST").equals(""))	{
		acar_gr9++;
		}else if( ht4.get("DEPT_ID").equals("0016") && ht4.get("LOAN_ST").equals(""))	{
		acar_u9++;
		}else if( ht4.get("DEPT_ID").equals("0017") && ht4.get("LOAN_ST").equals(""))	{
		acar_jr9++;
		}else if( ht4.get("DEPT_ID").equals("0018") && ht4.get("LOAN_ST").equals(""))	{
		acar_sp9++;
		}else if( ht4.get("DEPT_ID").equals("0005") && ht4.get("LOAN_ST").equals(""))	{
		acar_it9++;
		//�ӿ�(20180712)
		}else if( ht4.get("DEPT_ID").equals("0004") && ht4.get("LOAN_ST").equals(""))	{
		acar_exec9++;
		}
		
		acar_tot9 = acar_yk9 + acar_y9 + acar_k9 + acar_c9 + acar_b9 + acar_d9 + acar_s9 + acar_j9 + acar_g9 + acar_i9 + acar_w9 + acar_gs9 + acar_gr9 + acar_u9 + acar_jr9 + acar_sp9 + acar_it9 + acar_exec9;
		
		acar_tot89 = acar_tot8 + acar_tot9 ;

 		}
 		
// ���� �μ��� ��Ȳ

 		acar_yk01 = acar_yk0 + acar_yk1;
 		acar_y01 = acar_y0 + acar_y1;
		acar_k01 = acar_k0 + acar_k1;
		acar_c01 = acar_c0 + acar_c1;
		acar_it01 = acar_it0 + acar_it1;
		acar_exec01 = acar_exec0 + acar_exec1;	//�ӿ�(20180712)
																						
		acar_tot_ygc01 = acar_yk01 + acar_y01 + acar_k01 + acar_c01 + acar_it01 + acar_exec01;
		
		acar_b01 = acar_b0 + acar_b1;
		acar_d01 = acar_d0 + acar_d1;
		acar_s01 = acar_s0 + acar_s1;
		acar_j01 = acar_j0 + acar_j1;
		acar_g01 = acar_g0 + acar_g1;
		acar_i01 = acar_i0 + acar_i1;
		acar_w01 = acar_w0 + acar_w1;
		acar_gs01 = acar_gs0 + acar_gs1;
		acar_gr01 = acar_gr0 + acar_gr1;
		acar_u01 = acar_u0 + acar_u1;
		acar_jr01 = acar_jr0 + acar_jr1;
		acar_sp01 = acar_sp0 + acar_sp1;
		acar_tot_bd01 = acar_b01 + acar_d01 + acar_s01 + acar_j01 + acar_g01 + acar_i01 + acar_w01 + acar_gs01 + acar_gr01 + acar_u01 + acar_jr01 + acar_sp01;

// ����-1 �μ��� ��Ȳ
		acar_yk23 = acar_yk2 + acar_yk3;
		acar_y23 = acar_y2 + acar_y3;
		acar_k23 = acar_k2 + acar_k3;
		acar_c23 = acar_c2 + acar_c3;
		acar_it23 = acar_it2 + acar_it3;
		acar_exec23 = acar_exec2 + acar_exec3;	//�ӿ�(20180712)
																				
		acar_tot_ygc23 = acar_yk23 + acar_y23 + acar_k23 + acar_c23 + acar_it23 + acar_exec23;
		
		acar_b23 = acar_b2 + acar_b3;
		acar_d23 = acar_d2 + acar_d3;
		acar_s23 = acar_s2 + acar_s3;
		acar_j23 = acar_j2 + acar_j3;
		acar_g23 = acar_g2 + acar_g3;
		acar_i23 = acar_i2 + acar_i3;
		acar_w23 = acar_w2 + acar_w3;
		acar_gs23 = acar_gs2 + acar_gs3;
		acar_gr23 = acar_gr2 + acar_gr3;
		acar_u23 = acar_u2 + acar_u3;
		acar_jr23 = acar_jr2 + acar_jr3;
		acar_sp23 = acar_sp2 + acar_sp3;
		acar_tot_bd23 = acar_b23 + acar_d23 + acar_s23 + acar_j23 + acar_g23 + acar_i23 + acar_w23 + acar_gs23 + acar_gr23 + acar_u23 + acar_jr23 + acar_sp23;

// ����-2 �μ��� ��Ȳ
		acar_yk45 = acar_yk4 + acar_yk5;
		acar_y45 = acar_y4 + acar_y5;
		acar_k45 = acar_k4 + acar_k5;
		acar_c45 = acar_c4 + acar_c5;
		acar_it45 = acar_it4 + acar_it5;
		acar_exec45 = acar_exec4 + acar_exec5;	//�ӿ�(20180712)
		
		acar_tot_ygc45 = acar_yk45 + acar_y45 + acar_k45 + acar_c45 + acar_it45 + acar_exec45;
		
		acar_b45 = acar_b4 + acar_b5;
		acar_d45 = acar_d4 + acar_d5;
		acar_s45 = acar_s4 + acar_s5;
		acar_j45 = acar_j4 + acar_j5;
		acar_g45 = acar_g4 + acar_g5;
		acar_i45 = acar_i4 + acar_i5;
		acar_w45 = acar_w4 + acar_w5;
		acar_gs45 = acar_gs4 + acar_gs5;
		acar_gr45 = acar_gr4 + acar_gr5;
		acar_u45 = acar_u4 + acar_u5;
		acar_jr45 = acar_jr4 + acar_jr5;
		acar_sp45 = acar_sp4 + acar_sp5;
		acar_tot_bd45 = acar_b45 + acar_d45 + acar_s45 + acar_j45 + acar_g45 + acar_i45 + acar_w45 + acar_gs45 + acar_gr45 + acar_u45 + acar_jr45 + acar_sp45;

// ����-3 �μ��� ��Ȳ
		acar_yk67 = acar_yk6 + acar_yk7;
		acar_y67 = acar_y6 + acar_y7;
		acar_k67 = acar_k6 + acar_k7;
		acar_c67 = acar_c6 + acar_c7;
		acar_it67 = acar_it6 + acar_it7;
		acar_exec67 = acar_exec6 + acar_exec7;	//�ӿ�(20180712)
		
		acar_tot_ygc67 = acar_yk67 + acar_y67 + acar_k67 + acar_c67 + acar_it67 + acar_exec67;
		
		acar_b67 = acar_b6 + acar_b7;
		acar_d67 = acar_d6 + acar_d7;
		acar_s67 = acar_s6 + acar_s7;
		acar_j67 = acar_j6 + acar_j7;
		acar_g67 = acar_g6 + acar_g7;
		acar_i67 = acar_i6 + acar_i7;
		acar_w67 = acar_w6 + acar_w7;
		acar_gs67 = acar_gs6 + acar_gs7;
		acar_gr67 = acar_gr6 + acar_gr7;
		acar_u67 = acar_u6 + acar_u7;
		acar_jr67 = acar_jr6 + acar_jr7;
		acar_sp67 = acar_sp6 + acar_sp7;
		acar_tot_bd67 = acar_b67 + acar_d67 + acar_s67 + acar_j67 + acar_g67 + acar_i67 + acar_w67 + acar_gs67 + acar_gr67 + acar_u67 + acar_jr67 + acar_sp67;

// ����-4 �μ��� ��Ȳ
		acar_yk89 = acar_yk8 + acar_yk9;
		acar_y89 = acar_y8 + acar_y9;
		acar_k89 = acar_k8 + acar_k9;
		acar_c89 = acar_c8 + acar_c9;
		acar_it89 = acar_it8 + acar_it9;
		acar_exec89 = acar_exec8 + acar_exec9;	//�ӿ�(20180712)
		
		acar_tot_ygc89 = acar_yk89 + acar_y89 + acar_k89 + acar_c89 + acar_it89 + acar_exec89;
		
		acar_b89 = acar_b8 + acar_b9;
		acar_d89 = acar_d8 + acar_d9;
		acar_s89 = acar_s8 + acar_s9;
		acar_j89 = acar_j8 + acar_j9;
		acar_g89 = acar_g8 + acar_g9;
		acar_i89 = acar_i8 + acar_i9;
		acar_w89 = acar_w8 + acar_w9;
		acar_gs89 = acar_gs8 + acar_gs9;
		acar_gr89 = acar_gr8 + acar_gr9;
		acar_u89 = acar_u8 + acar_u9;
		acar_jr89 = acar_jr8 + acar_jr9;
		acar_sp89 = acar_sp8 + acar_sp9;
		acar_tot_bd89 = acar_b89 + acar_d89 + acar_s89 + acar_j89 + acar_g89 + acar_i89 + acar_w89 + acar_gs89 + acar_gr89 + acar_u89 + acar_jr89 + acar_sp89;
		

		
	
	
	
%> 	
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������Ȳ </span>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  �� �⵵�� 12�� 31�� �������� ��ȸ �Ǿ����ϴ�.</td>
    </tr>
    <tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr><td class=line2 colspan=2></td></tr>
		        <TR id='tr_title'>
		        	<td class='line2' id='td_title'>
		        		<table border="0" cellspacing="1" cellpadding="0" width=100%>
		        			<tr>
					          <TD width="28%" height="17" colspan="2" class='title'>����</TD>
					           <TD class='title'><%=nyear%>�� </TD>
					          <TD width="14%" class='title'><%=nyear-1%>�� </TD>
					          <TD width="14%" class='title'><%=nyear-2%>�� </TD>
					          <TD width="14%" class='title'><%=nyear-3%>�� </TD>
				              <TD width="14%" class='title'><%=nyear-4%>�� </TD>
		        			</TR>
					        <TR>
					          <TD rowspan="17" width="14%" height="103" class='title'>�ܱ���</TD>
					          <TD width="14%" height="103" class='title'>������ȹ��</TD>
					          <TD width="14%" height="103" valign="middle" align="center"><%=acar_yk0%>&nbsp;��</TD>
					          <TD width="14%" height="103" valign="middle" align="center"><%=acar_yk2%>&nbsp;��</TD>
					          <TD width="14%" height="103" valign="middle" align="center"><%=acar_yk4%>&nbsp;��</TD>
					          <TD width="14%" height="103" valign="middle" align="center"><%=acar_yk6%>&nbsp;��</TD>
					          <TD width="14%" height="103" valign="middle" align="center"><%=acar_yk8%>&nbsp;��</TD>
				          </TR>
				           <TR>
					          <TD width="14%" height="17" class='title'>������</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_y0%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_y2%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_y4%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_y6%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_y8%>&nbsp;��</TD>
				            </TR>
					        <TR>
					          <TD width="14%" height="17" class='title'>��������</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_k0%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_k2%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_k4%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_k6%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_k8%>&nbsp;��</TD>
				            </TR>
					        <TR>
					          <TD width="14%" height="17" class='title'>�ѹ���</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_c0%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_c2%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_c4%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_c6%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_c8%>&nbsp;��</TD>
				            </TR>
							 <TR>
					          <TD width="14%" height="17" class='title'>IT��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_it0%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_it2%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_it4%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_it6%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_it8%>&nbsp;��</TD>
				            </TR>
					        <TR>
					          <TD width="14%" height="17" class='title'>�λ�����</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_b0%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_b2%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_b4%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_b6%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_b8%>&nbsp;��</TD>
				            </TR>
					        <TR>
					          <TD width="14%" height="17" class='title'>��������</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_d0%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_d2%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_d4%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_d6%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_d8%>&nbsp;��</TD>
				            </TR>
							<TR>
					          <TD width="14%" height="17" class='title'>��������</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_s0%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_s2%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_s4%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_s6%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_s8%>&nbsp;��</TD>
				            </TR>
							<TR>
					          <TD width="14%" height="17" class='title'>��������</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_j0%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_j2%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_j4%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_j6%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_j8%>&nbsp;��</TD>
				            </TR>
							<TR>
					          <TD width="14%" height="17" class='title'>�뱸����</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_g0%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_g2%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_g4%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_g6%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_g8%>&nbsp;��</TD>
				            </TR>
							<TR>
					          <TD width="14%" height="17" class='title'>��õ����</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_i0%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_i2%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_i4%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_i6%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_i8%>&nbsp;��</TD>
				            </TR>
							<TR>
					          <TD width="14%" height="17" class='title'>��������</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_w0%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_w2%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_w4%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_w6%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_w8%>&nbsp;��</TD>
				            </TR>
							<TR>
					          <TD width="14%" height="17" class='title'>��������</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_gs0%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_gs2%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_gs4%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_gs6%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_gs8%>&nbsp;��</TD>
				            </TR>
							<TR>
					          <TD width="14%" height="17" class='title'>��������</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_gr0%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_gr2%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_gr4%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_gr6%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_gr8%>&nbsp;��</TD>
				            </TR>
							<%-- <TR>
					          <TD width="14%" height="17" class='title'>�������</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_u0%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_u2%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_u4%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_u6%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_u8%>&nbsp;��</TD>
				            </TR> --%>
							<TR>
					          <TD width="14%" height="17" class='title'>��ȭ������</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_jr0%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_jr2%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_jr4%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_jr6%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_jr8%>&nbsp;��</TD>
				            </TR>
							<TR>
					          <TD width="14%" height="17" class='title'>��������</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_sp0%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_sp2%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_sp4%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_sp6%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_sp8%>&nbsp;��</TD>
				            </TR>
					        <TR>
					          <TD width="14%" height="17" class='title'>�Ұ�</TD>
					          <TD width="14%" height="17" valign="middle" align="center" class='title'><%=acar_tot0%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center" class='title'><%=acar_tot2%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center" class='title'><%=acar_tot4%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center" class='title'><%=acar_tot6%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center" class='title'><%=acar_tot8%>&nbsp;��</TD>
				            </TR>
					        <TR>
					          <TD rowspan="18" width="14%" height="103" class='title'>������</TD>
					          <TD width="14%" height="103" class='title'>�ӿ�</TD>
					          <TD width="14%" height="103" valign="middle" align="center"><%=acar_exec1%>&nbsp;��</TD>
					          <TD width="14%" height="103" valign="middle" align="center"><%=acar_exec3%>&nbsp;��</TD>
					          <TD width="14%" height="103" valign="middle" align="center"><%=acar_exec5%>&nbsp;��</TD>
					          <TD width="14%" height="103" valign="middle" align="center"><%=acar_exec7%>&nbsp;��</TD>
					          <TD width="14%" height="103" valign="middle" align="center"><%=acar_exec9%>&nbsp;��</TD>
				            </TR>
			            <TR>
										<TD width="14%" height="103" class='title'>������ȹ��</TD>
					          <TD width="14%" height="103" valign="middle" align="center"><%=acar_yk1%>&nbsp;��</TD>
					          <TD width="14%" height="103" valign="middle" align="center"><%=acar_yk3%>&nbsp;��</TD>
					          <TD width="14%" height="103" valign="middle" align="center"><%=acar_yk5%>&nbsp;��</TD>
					          <TD width="14%" height="103" valign="middle" align="center"><%=acar_yk7%>&nbsp;��</TD>
					          <TD width="14%" height="103" valign="middle" align="center"><%=acar_yk9%>&nbsp;��</TD>
			            </TR>
									<TR>
										<TD width="14%" height="103" class='title'>������</TD>
					          <TD width="14%" height="103" valign="middle" align="center"><%=acar_y1%>&nbsp;��</TD>
					          <TD width="14%" height="103" valign="middle" align="center"><%=acar_y3%>&nbsp;��</TD>
					          <TD width="14%" height="103" valign="middle" align="center"><%=acar_y5%>&nbsp;��</TD>
					          <TD width="14%" height="103" valign="middle" align="center"><%=acar_y7%>&nbsp;��</TD>
					          <TD width="14%" height="103" valign="middle" align="center"><%=acar_y9%>&nbsp;��</TD>
				            </TR>
					        <TR>
					          <TD width="14%" height="17" class='title'>��������</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_k1%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_k3%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_k5%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_k7%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_k9%>&nbsp;��</TD>
				            </TR>
					        <TR>
					          <TD width="14%" height="17" class='title'>�ѹ���</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_c1%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_c3%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_c5%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_c7%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_c9%>&nbsp;��</TD>
				            </TR>
							 <TR>
					          <TD width="14%" height="17" class='title'>IT��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_it1%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_it3%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_it5%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_it7%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_it9%>&nbsp;��</TD>
				            </TR>
					        <TR>
					          <TD width="14%" height="17" class='title'>�λ�����</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_b1%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_b3%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_b5%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_b7%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_b9%>&nbsp;��</TD>
				            </TR>
					        <TR>
					          <TD width="14%" height="17" class='title'>��������</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_d1%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_d3%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_d5%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_d7%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_d9%>&nbsp;��</TD>
				            </TR>
							<TR>
					          <TD width="14%" height="17" class='title'>��������</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_s1%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_s3%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_s5%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_s7%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_s9%>&nbsp;��</TD>
				            </TR>
							<TR>
					          <TD width="14%" height="17" class='title'>��������</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_j1%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_j3%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_j5%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_j7%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_j9%>&nbsp;��</TD>
				            </TR>
							<TR>
					          <TD width="14%" height="17" class='title'>�뱸����</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_g1%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_g3%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_g5%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_g7%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_g9%>&nbsp;��</TD>
				            </TR>
							<TR>
					          <TD width="14%" height="17" class='title'>��õ����</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_i1%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_i3%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_i5%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_i7%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_i9%>&nbsp;��</TD>
				            </TR>
							<TR>
					          <TD width="14%" height="17" class='title'>��������</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_w1%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_w3%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_w5%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_w7%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_w9%>&nbsp;��</TD>
				            </TR>
							<TR>
					          <TD width="14%" height="17" class='title'>��������</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_gs1%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_gs3%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_gs5%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_gs7%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_gs9%>&nbsp;��</TD>
				            </TR>
							<TR>
					          <TD width="14%" height="17" class='title'>��������</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_gr1%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_gr3%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_gr5%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_gr7%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_gr9%>&nbsp;��</TD>
				            </TR>
							<%-- <TR>
					          <TD width="14%" height="17" class='title'>�������</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_u1%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_u3%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_u5%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_u7%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_u9%>&nbsp;��</TD>
				            </TR> --%>
							<TR>
					          <TD width="14%" height="17" class='title'>��ȭ������</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_jr1%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_jr3%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_jr5%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_jr7%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_jr9%>&nbsp;��</TD>
				            </TR>
							<TR>
					          <TD width="14%" height="17" class='title'>��������</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_sp1%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_sp3%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_sp5%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_sp7%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center"><%=acar_sp9%>&nbsp;��</TD>
				            </TR>
					        <TR>
					          <TD width="14%" height="17" class='title'>�Ұ�</TD>
					          <TD width="14%" height="17" valign="middle" align="center" class='title'><%=acar_tot1%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center" class='title'><%=acar_tot3%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center" class='title'><%=acar_tot5%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center" class='title'><%=acar_tot7%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center" class='title'><%=acar_tot9%>&nbsp;��</TD>
				            </TR>
					        <TR>
					          <TD width="28%" colspan="2" height="17" class='title'>�հ�</TD>
					          <TD width="14%" height="17" valign="middle" align="center" class='title'><%=acar_tot01%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center" class='title'><%=acar_tot23%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center" class='title'><%=acar_tot45%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center" class='title'><%=acar_tot67%>&nbsp;��</TD>
					          <TD width="14%" height="17" valign="middle" align="center" class='title'><%=acar_tot89%>&nbsp;��</TD>
				            </TR>
						</TABLE>
					</td>
				</tr>
			</table>
		</td>
    </tr>
    <tr>
    	<td class="h"></td>
    </tr>
    <tr>
    	<td class="h"></td>
    </tr>
    <tr>
    	<td class="h"></td>
    </tr>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�μ�����Ȳ</span></td>
    </tr>
    <tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr><td class=line2 colspan=2></td></tr>
		        <TR id='tr_title'>
		        	<td class='line2' id='td_title'>
		        		<table border="0" cellspacing="1" cellpadding="0" width=100%>
							<TR>
								<TD width="28%" height="27" colspan="2" class='title'>����</TD>
								<TD width="14%" class='title'><%=nyear%>�� </TD>
								<TD width="14%" class='title'><%=nyear-1%>�� </TD>
								<TD width="14%" class='title'><%=nyear-2%>�� </TD>
								<TD width="14%" class='title'><%=nyear-3%>�� </TD>
							    <TD width="14%" class='title'><%=nyear-4%>�� </TD>
							</TR>
							<TR>
								<TD rowspan="7" width="14%" height="68" class='title'>����</TD>
								<TD width="14%" height="68" class='title'>�ӿ�</TD>
								<TD width="14%" height="68" valign="middle" align="center"><%=acar_exec01%>&nbsp;��</TD>
								<TD width="14%" height="68" valign="middle" align="center"><%=acar_exec23%>&nbsp;��</TD>
								<TD width="14%" height="68" valign="middle" align="center"><%=acar_exec45%>&nbsp;��</TD>
								<TD width="14%" height="68" valign="middle" align="center"><%=acar_exec67%>&nbsp;��</TD>
								<TD width="14%" height="68" valign="middle" align="center"><%=acar_exec89%>&nbsp;��</TD>
							</TR>
							<TR>
							<TD width="14%" height="68" class='title'>������ȹ��</TD>
								<TD width="14%" height="68" valign="middle" align="center"><%=acar_yk01%>&nbsp;��</TD>
								<TD width="14%" height="68" valign="middle" align="center"><%=acar_yk23%>&nbsp;��</TD>
								<TD width="14%" height="68" valign="middle" align="center"><%=acar_yk45%>&nbsp;��</TD>
								<TD width="14%" height="68" valign="middle" align="center"><%=acar_yk67%>&nbsp;��</TD>
								<TD width="14%" height="68" valign="middle" align="center"><%=acar_yk89%>&nbsp;��</TD>
							</TR>
							<TR>
							<TD width="14%" height="68" class='title'>������</TD>
								<TD width="14%" height="68" valign="middle" align="center"><%=acar_y01%>&nbsp;��</TD>
								<TD width="14%" height="68" valign="middle" align="center"><%=acar_y23%>&nbsp;��</TD>
								<TD width="14%" height="68" valign="middle" align="center"><%=acar_y45%>&nbsp;��</TD>
								<TD width="14%" height="68" valign="middle" align="center"><%=acar_y67%>&nbsp;��</TD>
								<TD width="14%" height="68" valign="middle" align="center"><%=acar_y89%>&nbsp;��</TD>
							</TR>
							<TR>
								<TD width="14%" height="17" class='title'>��������</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_k01%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_k23%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_k45%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_k67%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_k89%>&nbsp;��</TD>
							</TR>
							<TR>
								<TD width="14%" height="17" class='title'>�ѹ���</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_c01%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_c23%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_c45%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_c67%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_c89%>&nbsp;��</TD>
							</TR>
							<TR>
								<TD width="14%" height="17" class='title'>IT��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_it01%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_it23%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_it45%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_it67%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_it89%>&nbsp;��</TD>
							</TR>
							<TR>
								<TD width="14%" height="17" class='title'>�Ұ�</TD>
								<TD width="14%" height="17" valign="middle" class='title' align="center" class='title'><%=acar_tot_ygc01%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" class='title' align="center" class='title'><%=acar_tot_ygc23%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" class='title' align="center" class='title'><%=acar_tot_ygc45%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" class='title' align="center" class='title'><%=acar_tot_ygc67%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" class='title' align="center" class='title'><%=acar_tot_ygc89%>&nbsp;��</TD>
							</TR>
							<TR>
								<TD rowspan="13" width="14%" height="51" class='title'>����</TD>
								<TD width="14%" height="51" class='title'>�λ�����</TD>
								<TD width="14%" height="51" valign="middle" align="center"><%=acar_b01%>&nbsp;��</TD>
								<TD width="14%" height="51" valign="middle" align="center"><%=acar_b23%>&nbsp;��</TD>
								<TD width="14%" height="51" valign="middle" align="center"><%=acar_b45%>&nbsp;��</TD>
								<TD width="14%" height="51" valign="middle" align="center"><%=acar_b67%>&nbsp;��</TD>
								<TD width="14%" height="51" valign="middle" align="center"><%=acar_b89%>&nbsp;��</TD>
							</TR>
							<TR>
								<TD width="14%" height="17" class='title'>��������</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_d01%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_d23%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_d45%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_d67%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_d89%>&nbsp;��</TD>
							</TR>
							<TR>
								<TD width="14%" height="17" class='title'>��������</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_s01%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_s23%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_s45%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_s67%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_s89%>&nbsp;��</TD>
							</TR>
							<TR>
								<TD width="14%" height="17" class='title'>��������</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_j01%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_j23%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_j45%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_j67%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_j89%>&nbsp;��</TD>
							</TR>
							<TR>
								<TD width="14%" height="17" class='title'>�뱸����</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_g01%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_g23%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_g45%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_g67%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_g89%>&nbsp;��</TD>
							</TR>
							<TR>
								<TD width="14%" height="17" class='title'>��õ����</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_i01%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_i23%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_i45%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_i67%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_i89%>&nbsp;��</TD>
							</TR>
							<TR>
								<TD width="14%" height="17" class='title'>��������</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_w01%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_w23%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_w45%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_w67%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_w89%>&nbsp;��</TD>
							</TR>
							<TR>
								<TD width="14%" height="17" class='title'>��������</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_gs01%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_gs23%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_gs45%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_gs67%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_gs89%>&nbsp;��</TD>
							</TR>
							<TR>
								<TD width="14%" height="17" class='title'>��������</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_gr01%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_gr23%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_gr45%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_gr67%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_gr89%>&nbsp;��</TD>
							</TR>
							<TR>
								<TD width="14%" height="17" class='title'>�������</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_u01%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_u23%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_u45%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_u67%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_u89%>&nbsp;��</TD>
							</TR>
							<TR>
								<TD width="14%" height="17" class='title'>��ȭ������</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_jr01%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_jr23%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_jr45%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_jr67%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_jr89%>&nbsp;��</TD>
							</TR>
							<TR>
								<TD width="14%" height="17" class='title'>��������</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_sp01%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_sp23%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_sp45%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_sp67%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" align="center"><%=acar_sp89%>&nbsp;��</TD>
							</TR>
							<TR>
								<TD width="14%" height="17" class='title'>�Ұ�</TD>
								<TD width="14%" height="17" valign="middle" class='title' align="center" class='title'><%=acar_tot_bd01%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" class='title' align="center" class='title'><%=acar_tot_bd23%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" class='title' align="center" class='title'><%=acar_tot_bd45%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" class='title' align="center" class='title'><%=acar_tot_bd67%>&nbsp;��</TD>
								<TD width="14%" height="17" valign="middle" class='title' align="center" class='title'><%=acar_tot_bd89%>&nbsp;��</TD>
							</TR>
							<TR>
								<TD colspan="2" width="28%" height="17" class='title'>�հ�</TD>
								<TD width="14%" height="17" valign="middle" align="center" class='title'><%=acar_tot01%>&nbsp;��</TD>
						        <TD width="14%" height="17" valign="middle" align="center" class='title'><%=acar_tot23%>&nbsp;��</TD>
						        <TD width="14%" height="17" valign="middle" align="center" class='title'><%=acar_tot45%>&nbsp;��</TD>
						        <TD width="14%" height="17" valign="middle" align="center" class='title'><%=acar_tot67%>&nbsp;��</TD>
						        <TD width="14%" height="17" valign="middle" align="center" class='title'><%=acar_tot89%>&nbsp;��</TD>
							</TR>
						</TABLE>
					</td>
				</tr>
			</table>
		</td>
	</tr>  
</table>
</form>
</body>
</html>