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
	
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String height 	= request.getParameter("height")==null?"":request.getParameter("height");
	String asc 	= request.getParameter("asc")==null?"":request.getParameter("asc");	

	String basic_dt 		= request.getParameter("basic_dt")==null?"":request.getParameter("basic_dt");
	String basic_dt_input	= request.getParameter("basic_dt_input")==null?"":request.getParameter("basic_dt_input");

	if(basic_dt.equals("")){
		 basic_dt = AddUtil.getDate(1)+"0101";
	}
	//�ټӳ������Ȳ
	int under1_male=0;//1���� �̸� ����
	int under3_male=0;//1�� - 3�� ����
	int under5_male=0;//3�� - 5�� ����
	int under10_male=0;//5�� - 10�� ����
	int over10_male=0;//10�� �̻� ����
	
	int tot_male=0; //���� �հ�
	
	double per_under1_male=0;
	double per_under3_male=0;
	double per_under5_male=0;
	double per_under10_male=0;
	double per_over10_male=0;
	
	double tot_per_male=0;
	
	int under1_female=0;
	int under3_female=0;
	int under5_female=0;
	int under10_female=0;
	int over10_female=0;
	
	int tot_female=0;
	
	//�ټӳ������Ȳ ����
	double per_under1_female=0;
	double per_under3_female=0;
	double per_under5_female=0;
	double per_under10_female=0;
	double per_over10_female=0;
	
	double tot_per_female=0;
	
	int under1_all=0;
	int under3_all=0;
	int under5_all=0;
	int under10_all=0;
	int over10_all=0;
	
	int tot_all=0;
	
	double per_under1_all=0;
	double per_under3_all=0;
	double per_under5_all=0;
	double per_under10_all=0;
	double per_over10_all=0;
	
	double tot_per_all=0;
	
	//�ٹ����º���Ȳ
	int inside_male01=0;
	int inside_male02=0;
	int inside_male03=0;
	int inside_male04=0;
	int inside_male05=0;
	int inside_male07=0;
	int inside_male08=0;
	int inside_male09=0;
	int inside_male10=0;
	int inside_male11=0;
	int inside_male12=0;
	int inside_male13=0;
	int inside_male14=0;
	int inside_male15=0;
	int inside_male16=0;
	int inside_male17=0;
	int inside_male18=0;
	int inside_male19=0;
	int inside_male20=0;
	
	int inside_male=0;//���� ������
	
	int inside_female01=0;
	int inside_female02=0;
	int inside_female03=0;
	int inside_female04=0;
	int inside_female05=0;
	int inside_female07=0;
	int inside_female08=0;
	int inside_female09=0;
	int inside_female10=0;
	int inside_female11=0;
	int inside_female12=0;
	int inside_female13=0;
	int inside_female14=0;
	int inside_female15=0;
	int inside_female16=0;
	int inside_female17=0;
	int inside_female18=0;
	int inside_female19=0;
	int inside_female20=0;
	
	int inside_female=0;//���� ������
	
	int outside_male01=0;
	int outside_male02=0;
	int outside_male03=0;
	int outside_male04=0;
	int outside_male05=0;
	int outside_male07=0;
	int outside_male08=0;
	int outside_male09=0;
	int outside_male10=0;
	int outside_male11=0;
	int outside_male12=0;
	int outside_male13=0;
	int outside_male14=0;
	int outside_male15=0;
	int outside_male16=0;
	int outside_male17=0;
	int outside_male18=0;
	int outside_male19=0;
	
	int outside_male=0;//���� �ܱ���
	
	int outside_female01=0;
	int outside_female02=0;
	int outside_female03=0;
	int outside_female04=0;
	int outside_female05=0;
	int outside_female07=0;
	int outside_female08=0;
	int outside_female09=0;
	int outside_female10=0;
	int outside_female11=0;
	int outside_female12=0;
	int outside_female13=0;
	int outside_female14=0;
	int outside_female15=0;
	int outside_female16=0;
	int outside_female17=0;
	int outside_female18=0;
	int outside_female19=0;
	
	int outside_female=0;//���� �ܱ���
	
	int inside=0;
	int outside=0;
	
	double per_inside_male=0;
	double per_outside_male=0;
	double per_inside_female=0;
	double per_outside_female=0;
	
	double per_inside=0;
	double per_outside=0;
	
	//����� ���� ��ȸ
	Vector vt = ic_db.Insa_promotion2(basic_dt);
	int vt_size = vt.size();
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script type="text/javascript">
function search2(){
	var fm = document.form1;		
	if($("#basic_dt_sel option:selected").val()=="directInput"){
		fm.basic_dt.value = fm.basic_dt_input.value;
	}else{
		fm.basic_dt.value = $("#basic_dt_sel option:selected").val();
		fm.basic_dt_input.value = "";
	}
	if(fm.basic_dt.value==""){
		alert("�������ڸ� ����/�Է� ���ּ���.");
		return;
	}
	fm.action = "gy2_sc_in.jsp";
	fm.target='_self';
	fm.submit();
}

//�������� ���ùڽ� ����
function selectBasic_dt(val){
	if(val=="directInput"){	$("#hidden_span1").css("display", "block");		}
	else{					$("#hidden_span1").css("display", "none");		}
}

</script>
</head>
<body>
<form action="" name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">  
<%
//��������

String jumin = "";
String gender = "";

for(int i = 0 ; i < vt_size ; i++){
	Hashtable ht = (Hashtable)vt.elementAt(i);
	
		jumin = String.valueOf(ht.get("USER_SSN"));
		gender = jumin.substring(6, 7);	
	
		if(gender.equals("1") && ht.get("YEAR").equals("0") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){	under1_male++;}//1�� �̸� ��
		else if(gender.equals("1") && AddUtil.parseLong(String.valueOf(ht.get("YEAR"))) >= 1 && AddUtil.parseLong(String.valueOf(ht.get("YEAR"))) < 3)	{		under3_male++;		}//1�� �̻� ~ 3�� �̸� ��
		else if(gender.equals("1") && AddUtil.parseLong(String.valueOf(ht.get("YEAR"))) >= 3 && AddUtil.parseLong(String.valueOf(ht.get("YEAR"))) < 5)	{		under5_male++;		}//3�� �̻� ~ 5�� �̸� ��
		else if(gender.equals("1") && AddUtil.parseLong(String.valueOf(ht.get("YEAR"))) >= 5 && AddUtil.parseLong(String.valueOf(ht.get("YEAR"))) < 10)	{		under10_male++;		}//5�� �̻� ~ 10�� �̸� ��
		else if(gender.equals("1") && AddUtil.parseLong(String.valueOf(ht.get("YEAR"))) >= 10)																				{		over10_male++;		}//10�� �̻� ��

		tot_male = under1_male + under3_male + under5_male + under10_male + over10_male;
		
		per_under1_male = (double)under1_male/ tot_all * 100;
		per_under3_male = (double)under3_male/ tot_all * 100;
		per_under5_male = (double)under5_male/ tot_all * 100;
		per_under10_male = (double)under10_male/ tot_all * 100;
		per_over10_male = (double)over10_male/ tot_all * 100;
		
		tot_per_male = per_under1_male + per_under3_male + per_under5_male + per_under10_male + per_over10_male;
		
		if(gender.equals("2") && ht.get("YEAR").equals("0") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){	under1_female++;}//1�� �̸� ��
		else if(gender.equals("2") && AddUtil.parseLong(String.valueOf(ht.get("YEAR"))) >= 1 && AddUtil.parseLong(String.valueOf(ht.get("YEAR"))) < 3)	{		under3_female++;		}//1�� �̻� ~ 3�� �̸� ��
		else if(gender.equals("2") && AddUtil.parseLong(String.valueOf(ht.get("YEAR"))) >= 3 && AddUtil.parseLong(String.valueOf(ht.get("YEAR"))) < 5)	{		under5_female++;		}//3�� �̻� ~ 5�� �̸� ��
		else if(gender.equals("2") && AddUtil.parseLong(String.valueOf(ht.get("YEAR"))) >= 5 && AddUtil.parseLong(String.valueOf(ht.get("YEAR"))) < 10)	{		under10_female++;		}//5�� �̻� ~ 10�� �̸� ��
		else if(gender.equals("2") && AddUtil.parseLong(String.valueOf(ht.get("YEAR"))) >= 10)																				{		over10_female++;		}//10�� �̻� ��
		
		tot_female = under1_female + under3_female + under5_female + under10_female + over10_female;
		
		per_under1_female = (double)under1_female/ tot_all * 100;
		per_under3_female = (double)under3_female/ tot_all * 100;
		per_under5_female = (double)under5_female/ tot_all * 100;
		per_under10_female = (double)under10_female/ tot_all * 100;
		per_over10_female = (double)over10_female/ tot_all * 100;
		
		tot_per_female = per_under1_female + per_under3_female + per_under5_female + per_under10_female + per_over10_female;
		
		if(ht.get("YEAR").equals("0") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){	under1_all++;}//1�� �̸� ��
		else if(AddUtil.parseLong(String.valueOf(ht.get("YEAR"))) >= 1 && AddUtil.parseLong(String.valueOf(ht.get("YEAR"))) < 3)		{		under3_all++;		}//1�� �̻� ~ 3�� �̸� ��
		else if(AddUtil.parseLong(String.valueOf(ht.get("YEAR"))) >= 3 && AddUtil.parseLong(String.valueOf(ht.get("YEAR"))) < 5)		{		under5_all++;		}//3�� �̻� ~ 5�� �̸� ��
		else if(AddUtil.parseLong(String.valueOf(ht.get("YEAR"))) >= 5 && AddUtil.parseLong(String.valueOf(ht.get("YEAR"))) < 10)	{		under10_all++;		}//5�� �̻� ~ 10�� �̸� ��
		else if(AddUtil.parseLong(String.valueOf(ht.get("YEAR"))) >= 10)																			{		over10_all++;		}//10�� �̻� ��
	
		tot_all = under1_all + under3_all + under5_all + under10_all + over10_all;
		
		per_under1_all = (double)under1_all/ tot_all * 100;
		per_under3_all = (double)under3_all/ tot_all * 100;
		per_under5_all = (double)under5_all/ tot_all * 100;
		per_under10_all = (double)under10_all/ tot_all * 100;
		per_over10_all = (double)over10_all/ tot_all * 100;
		
		tot_per_all = per_under1_all + per_under3_all + per_under5_all + per_under10_all + per_over10_all;
}
	
%> 
<%
for(int i = 0 ; i < vt_size ; i++){
	Hashtable ht = (Hashtable)vt.elementAt(i);
	
	jumin = String.valueOf(ht.get("USER_SSN"));
	gender = jumin.substring(6,7);		
	
	if(ht.get("DEPT_ID").equals("0001") && gender.equals("1") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_male01++; }
	else if(ht.get("DEPT_ID").equals("0020") && gender.equals("1") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_male19++; }
	else if(ht.get("DEPT_ID").equals("0002") && gender.equals("1") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_male01++; }
	else if(ht.get("DEPT_ID").equals("0003") && gender.equals("1") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_male02++; }
	else if(ht.get("DEPT_ID").equals("0005") && gender.equals("1") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_male03++; }
	else if(ht.get("DEPT_ID").equals("0007") && gender.equals("1") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_male05++; }
	else if(ht.get("DEPT_ID").equals("0008") && gender.equals("1") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_male07++; }
	else if(ht.get("DEPT_ID").equals("0009") && gender.equals("1") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_male08++; }
	else if(ht.get("DEPT_ID").equals("0010") && gender.equals("1") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_male09++; }
	else if(ht.get("DEPT_ID").equals("0011") && gender.equals("1") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_male10++; }
	else if(ht.get("DEPT_ID").equals("0012") && gender.equals("1") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_male11++; }
	else if(ht.get("DEPT_ID").equals("0013") && gender.equals("1") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_male12++; }
	else if(ht.get("DEPT_ID").equals("0014") && gender.equals("1") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_male13++; }
	else if(ht.get("DEPT_ID").equals("0015") && gender.equals("1") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_male14++; }
	else if(ht.get("DEPT_ID").equals("0016") && gender.equals("1") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_male15++; }
	else if(ht.get("DEPT_ID").equals("0017") && gender.equals("1") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_male16++; }
	else if(ht.get("DEPT_ID").equals("0018") && gender.equals("1") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_male17++; }
	else if(ht.get("DEPT_ID").equals("0004") && gender.equals("1") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_male20++; }
	
	inside_male = inside_male01 + inside_male02 + inside_male03 + inside_male05 + inside_male07 + inside_male08 + inside_male09 + inside_male10 + inside_male11 + inside_male12 + inside_male13 + inside_male14 + inside_male15 + inside_male16 +inside_male17 + inside_male19 + inside_male18 + inside_male20;

	if(ht.get("DEPT_ID").equals("0001") && gender.equals("2") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_female01++; }
	else if(ht.get("DEPT_ID").equals("0020") && gender.equals("2") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_female19++; }
	else if(ht.get("DEPT_ID").equals("0002") && gender.equals("2") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_female01++; }
	else if(ht.get("DEPT_ID").equals("0003") && gender.equals("2") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_female02++; }
	else if(ht.get("DEPT_ID").equals("0005") && gender.equals("2") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_female03++; }
	else if(ht.get("DEPT_ID").equals("0007") && gender.equals("2") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_female05++; }
	else if(ht.get("DEPT_ID").equals("0008") && gender.equals("2") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_female07++; }
	else if(ht.get("DEPT_ID").equals("0009") && gender.equals("2") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_female08++; }
	else if(ht.get("DEPT_ID").equals("0010") && gender.equals("2") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_female09++; }
	else if(ht.get("DEPT_ID").equals("0011") && gender.equals("2") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_female10++; }
	else if(ht.get("DEPT_ID").equals("0012") && gender.equals("2") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_female11++; }
	else if(ht.get("DEPT_ID").equals("0013") && gender.equals("2") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_female12++; }
	else if(ht.get("DEPT_ID").equals("0014") && gender.equals("2") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_female13++; }
	else if(ht.get("DEPT_ID").equals("0015") && gender.equals("2") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_female14++; }
	else if(ht.get("DEPT_ID").equals("0016") && gender.equals("2") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_female15++; }
	else if(ht.get("DEPT_ID").equals("0017") && gender.equals("2") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_female16++; }
	else if(ht.get("DEPT_ID").equals("0018") && gender.equals("2") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_female17++; }
	else if(ht.get("DEPT_ID").equals("0004") && gender.equals("2") && ht.get("LOAN_ST").equals("") && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  inside_female20++; }
	
	inside_female = inside_female01 + inside_female02 + inside_female03 + inside_female05 + inside_female07 + inside_female08 + inside_female09 + inside_female10 + inside_female11 + inside_female12 + inside_female13 + inside_female14 + inside_female15 + inside_female16 +inside_female17  +inside_female19 + inside_female18 + inside_female20;

	if(ht.get("DEPT_ID").equals("0001") && gender.equals("1") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_male01++; }
	else if(ht.get("DEPT_ID").equals("0020") && gender.equals("1") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_male19++; }
	else if(ht.get("DEPT_ID").equals("0002") && gender.equals("1") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_male01++; }
	else if(ht.get("DEPT_ID").equals("0003") && gender.equals("1") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_male02++; }
	else if(ht.get("DEPT_ID").equals("0005") && gender.equals("1") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_male03++; }
	else if(ht.get("DEPT_ID").equals("0007") && gender.equals("1") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_male05++; }
	else if(ht.get("DEPT_ID").equals("0008") && gender.equals("1") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_male07++; }
	else if(ht.get("DEPT_ID").equals("0009") && gender.equals("1") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_male08++; }
	else if(ht.get("DEPT_ID").equals("0010") && gender.equals("1") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_male09++; }
	else if(ht.get("DEPT_ID").equals("0011") && gender.equals("1") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_male10++; }
	else if(ht.get("DEPT_ID").equals("0012") && gender.equals("1") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_male11++; }
	else if(ht.get("DEPT_ID").equals("0013") && gender.equals("1") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_male12++; }
	else if(ht.get("DEPT_ID").equals("0014") && gender.equals("1") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_male13++; }
	else if(ht.get("DEPT_ID").equals("0015") && gender.equals("1") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_male14++; }
	else if(ht.get("DEPT_ID").equals("0016") && gender.equals("1") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_male15++; }
	else if(ht.get("DEPT_ID").equals("0017") && gender.equals("1") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_male16++; }
	else if(ht.get("DEPT_ID").equals("0018") && gender.equals("1") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_male17++; }
	
	outside_male = outside_male01 + outside_male02 + outside_male03 + outside_male05 + outside_male07 + outside_male08 + outside_male09 + outside_male10 + outside_male11 + outside_male12 + outside_male13 + outside_male14 + outside_male15 + outside_male16 +outside_male17 + outside_male18+ outside_male19;
	
	if(ht.get("DEPT_ID").equals("0001") && gender.equals("2") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_female01++; }
	else if(ht.get("DEPT_ID").equals("0020") && gender.equals("2") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_female19++; }
	else if(ht.get("DEPT_ID").equals("0002") && gender.equals("2") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_female01++; }
	else if(ht.get("DEPT_ID").equals("0003") && gender.equals("2") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_female02++; }
	else if(ht.get("DEPT_ID").equals("0005") && gender.equals("2") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_female03++; }
	else if(ht.get("DEPT_ID").equals("0007") && gender.equals("2") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_female05++; }
	else if(ht.get("DEPT_ID").equals("0008") && gender.equals("2") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_female07++; }
	else if(ht.get("DEPT_ID").equals("0009") && gender.equals("2") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_female08++; }
	else if(ht.get("DEPT_ID").equals("0010") && gender.equals("2") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_female09++; }
	else if(ht.get("DEPT_ID").equals("0011") && gender.equals("2") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_female10++; }
	else if(ht.get("DEPT_ID").equals("0012") && gender.equals("2") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_female11++; }
	else if(ht.get("DEPT_ID").equals("0013") && gender.equals("2") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_female12++; }
	else if(ht.get("DEPT_ID").equals("0014") && gender.equals("2") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_female13++; }
	else if(ht.get("DEPT_ID").equals("0015") && gender.equals("2") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_female14++; }
	else if(ht.get("DEPT_ID").equals("0016") && gender.equals("2") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_female15++; }
	else if(ht.get("DEPT_ID").equals("0017") && gender.equals("2") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_female16++; }
	else if(ht.get("DEPT_ID").equals("0018") && gender.equals("2") && (ht.get("LOAN_ST").equals("2") || ht.get("LOAN_ST").equals("1")) && AddUtil.parseLong(String.valueOf(ht.get("MONTH"))) >= 0){  outside_female17++; }
	
	outside_female = outside_female01 + outside_female02 + outside_female03 + outside_female05 + outside_female07 + outside_female08 + outside_female09 + outside_female10 + outside_female11 + outside_female12 + outside_female13 + outside_female14 + outside_female15 + outside_female16 +outside_female17+outside_female19 + outside_female18;

	inside = inside_male + inside_female;
	outside = outside_male + outside_female;
	
	per_inside_male = (double)inside_male / tot_all * 100;
	per_outside_male = (double)outside_male / tot_all * 100;
	per_inside_female = (double)inside_female / tot_all * 100;
	per_outside_female = (double)outside_female / tot_all * 100;
	

	per_inside = (double)inside / tot_all * 100;
	per_outside = (double)outside / tot_all * 100;
}
%>



	<table border="0" cellspacing="0" cellpadding="0" width=100%>	
		<tr>
			<td colspan="2">
				<table>
					<tr>
						<td>
							<img src=/acar/images/center/icon_arrow.gif align=absmiddle>
							<span class=style2>��ȸ(�⵵�� ��Ȳ, ���� ��Ȳ)</span>
							�������� : <SELECT id="basic_dt_sel" onchange="javascript:selectBasic_dt(this.value);">
											<OPTION VALUE="20120101" <%if(basic_dt.equals("20120101")){%>selected<%}%>>2012-01-01</OPTION>
											<OPTION VALUE="20130101" <%if(basic_dt.equals("20130101")){%>selected<%}%>>2013-01-01</OPTION>
											<OPTION VALUE="20140101" <%if(basic_dt.equals("20140101")){%>selected<%}%>>2014-01-01</OPTION>
											<OPTION VALUE="20150101" <%if(basic_dt.equals("20150101")){%>selected<%}%>>2015-01-01</OPTION>
											<OPTION VALUE="20160101" <%if(basic_dt.equals("20160101")){%>selected<%}%>>2016-01-01</OPTION>
											<OPTION VALUE="20170101" <%if(basic_dt.equals("20170101")){%>selected<%}%>>2017-01-01</OPTION>
											<OPTION VALUE="20180101" <%if(basic_dt.equals("20180101")){%>selected<%}%>>2018-01-01</OPTION>
											<OPTION VALUE="20190101" <%if(basic_dt.equals("20190101")){%>selected<%}%>>2019-01-01</OPTION>
											<OPTION VALUE="20200101" <%if(basic_dt.equals("20200101")){%>selected<%}%>>2020-01-01</OPTION>
											<OPTION VALUE="directInput"<%if(!basic_dt_input.equals("")){%>selected<%}%>>�����Է�</OPTION>
									</SELECT>
							<input type="hidden" name="basic_dt" value="">
						</td>
						<td>
							<span id="hidden_span1" style="display:<%if(!basic_dt_input.equals("")){%>'';<%}else{%>none;<%}%>">
								&nbsp;&nbsp;<input type="text" class="text" name="basic_dt_input" value="<%=basic_dt_input%>" placeholder="��)20180711">
							</span>
						</td>
						<td>&nbsp;&nbsp;
							<a href="javascript:search2()"><img src=/acar/images/center/button_see.gif align=absmiddle border=0></a>
						</td>
					</tr>
				</table>
						
				
			</td>
		</tr>
		<tr id='tr_title'>
			<td class='line2' id='td_title'>
				<table border="0" cellspacing="1" cellpadding="0" width=100%>
					<tr>
						<td width="28%" colspan="2" class='title' rowspan="2">����</td>
						<td class='title' colspan="2">�ٹ����º���Ȳ</td>
						<td class='title' colspan="6">�ټӳ������Ȳ</td>
					</tr>
					<tr>
						<td width="10%" class='title' width="10%">������</td>
						<td width="10%" class='title' width="10%">�ܱ���</td>
						<td width="10%" class='title' width="10%">1��̸�</td>
						<td width="10%" class='title' width="10%" style ="padding:5px;">1���̻�<br>~ 3��̸�</td>
						<td width="10%" class='title' width="10%">3���̻�<br>~ 5��̸�</td>
						<td width="10%" class='title' width="10%">5���̻�<br>~ 10��̸�</td>
						<td width="10%" class='title' width="10%">10���̻�</td>
						<td width="10%" class='title' width="10%">�հ�</td>
					</tr>
					<tr>
						<td width="10%" class='title' rowspan="2" id="twoline">��</td>
						<td width="10%" class='title' width="10%">�ο�</td>
						<td align="center"><%=inside_male%> ��</td>
						<td align="center"><%=outside_male%> ��</td>
						<td align="center"><%=under1_male%> ��</td>
						<td align="center"><%=under3_male%> ��</td>
						<td align="center"><%=under5_male%> ��</td>
						<td align="center"><%=under10_male%> ��</td>
						<td align="center"><%=over10_male%> ��</td>
						<td align="center"><%=tot_male%> ��</td>
					</tr>
					<tr>
						<td class='title'>����</td>
						<td align="center"><%=Math.round(per_inside_male)%> %</td>
						<td align="center"><%=Math.round(per_outside_male)%> %</td>
						<td align="center"><%=Math.round(per_under1_male)%> %</td>
						<td align="center"><%=Math.round(per_under3_male)%> %</td>
						<td align="center"><%=Math.round(per_under5_male)%> %</td>
						<td align="center"><%=Math.round(per_under10_male)%> %</td>
						<td align="center"><%=Math.round(per_over10_male)%> %</td>
						<td align="center"><%=Math.round(tot_per_male)%> %</td>
					</tr>
					<tr>
					<tr>
						<td class='title' rowspan="2">��</td>
						<td class='title'>�ο�</td>
						<td align="center"><%=inside_female%> ��</td>
						<td align="center"><%=outside_female%> ��</td>
						<td align="center"><%=under1_female%> ��</td>
						<td align="center"><%=under3_female%> ��</td>
						<td align="center"><%=under5_female%> ��</td>
						<td align="center"><%=under10_female%> ��</td>
						<td align="center"><%=over10_female%> ��</td>
						<td align="center"><%=tot_female%> ��</td>
					</tr>
					<tr>
						<td class='title'>����</td>
						<td align="center"><%=Math.round(per_inside_female)%> %</td>
						<td align="center"><%=Math.round(per_outside_female)%> %</td>
						<td align="center"><%=Math.round(per_under1_female)%> %</td>
						<td align="center"><%=Math.round(per_under3_female)%> %</td>
						<td align="center"><%=Math.round(per_under5_female)%> %</td>
						<td align="center"><%=Math.round(per_under10_female)%> %</td>
						<td align="center"><%=Math.round(per_over10_female)%> %</td>
						<td align="center"><%=Math.round(tot_per_female)%> %</td>
					</tr>
					<tr>
						<td class='title' rowspan="2">�հ�</td>
						<td class='title'>�ο�</td>
						<td align="center"><%=inside%> ��</td>
						<td align="center"><%=outside%> ��</td>
						<td align="center"><%=under1_all%> ��</td>
						<td align="center"><%=under3_all%> ��</td>
						<td align="center"><%=under5_all%> ��</td>
						<td align="center"><%=under10_all%> ��</td>
						<td align="center"><%=over10_all%> ��</td>
						<td align="center"><%=tot_all%> ��</td>
					</tr>
					<tr>
						<td class='title'>����</td>
						<td align="center"><%=Math.round(per_inside)%> %</td>
						<td align="center"><%=Math.round(per_outside)%> %</td>
						<td align="center"><%=Math.round(per_under1_all)%> %</td>
						<td align="center"><%=Math.round(per_under3_all)%> %</td>
						<td align="center"><%=Math.round(per_under5_all)%> %</td>
						<td align="center"><%=Math.round(per_under10_all)%> %</td>
						<td align="center"><%=Math.round(per_over10_all)%> %</td>
						<td align="center"><%=Math.round(tot_per_all)%> %</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
</body>
</html>