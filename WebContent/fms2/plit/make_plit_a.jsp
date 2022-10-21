<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>


<%
String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");
String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");

String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");  //1:급여소득(직원), 2:사업/기타소득(영업사원등)


//프로시저 호출
int flag2 = 0;
String  d_flag1 =  ad_db.call_sp_make_plit(st_year, AddUtil.addZero(st_mon), gubun);
if (!d_flag1.equals("0")) flag2 = 1;
System.out.println(" 귀속년월 인사/급여 데이타  등록 "+st_year + "|"+ AddUtil.addZero(st_mon) + "|" + gubun);
System.out.println(d_flag1);
System.out.println(AddUtil.getDate());
%>
<form name='form1'  target='d_content' method="POST">
<input type='hidden' name='st_year' value='<%=st_year%>'>
<input type='hidden' name='st_mon' value='<%=st_mon%>'>

</form>
<script language='javascript'>

var fm = document.form1;
<%	if(flag2 != 0){%>
alert('등록 오류 발생!');
<%	}else{%>
alert('등록되었습니다.');	
parent.window.close();	
<%	}%>

</script>
</body>
</html>