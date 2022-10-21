<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR" %>
<%@ page import="java.util.*,acar.util.*"%>

<%
	
int st_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
int st_mon = request.getParameter("s_mon")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_mon"));	
int year =AddUtil.getDate2(1);
	
%>

	
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>FMS CAR API</title>
<script type="text/javascript" src="http://code.jquery.com/jquery.js"></script>

<script type="text/javascript">

function make_plit(){
	var fm = document.form1;
	//var url = document.location.href;
	if(confirm('해당 귀속년월의 급여 연동데이터를 생성하시겠습니까?')){
		window.open('about:blank', "saveAllCarEndDt", "width=500, height=200");
		fm.target = "saveAllCarEndDt";		
		fm.action = "make_plit_a.jsp?gubun=1";
		fm.submit();
	}
}

function make_plit1(){
	var fm = document.form1;
	//var url = document.location.href;
	if(confirm('해당 귀속년월의 사업/기타 연동데이터를 생성하시겠습니까?')){
		window.open('about:blank', "saveAllCarEndDt", "width=500, height=200");
		fm.target = "saveAllCarEndDt";		
		fm.action = "make_plit_a.jsp?gubun=2";
		fm.submit();
	}
}

</script>

<style type="text/css">
	*{
	font-family:'Nanum Barun Gothic';
	}
	
	body{
	margin: 0 auto; 
	width: 765px;
	 }
	
	h1{
	margin-left:auto; 
	margin-right:auto; 
	margin-top:30px;
	width: 265px; 
	}
	
	hr{
	width:765px;
	border:thin solid #e9efed;
	}
	
	.formContent{
	width:765px;
	border-top: b
	}
	
	
	tr{
	padding: 10px 35px; 
	margin-top:15px;
	height: 80px;
	}
	
	th{
	text-align: left;
	 width:180px; 
	 margin-top: 15px;
	 }
	
	td{
	text-align: left; 
	width:515px;
	margin-top: 15px;
	}
	
	#authorize{
	background-color: #0ab044; 
	color: #FFF; 
	font-size:16px;
	text-align: center; 
	border-radius: 5px; 
	padding: 10px 15p; 
	margin: 10px;
	width: 180px;
    height: 50px;
    border-color:none;

}
	#btn_reset{
	background-color: #9e9e9e; 
	color: #FFF; 
	font-size:16px;
	text-align: center; 
	border-radius: 5px; 
	padding: 10px 15p; 
	margin: 10px;
	width: 180px;
    height: 50px;

}
    select      { height: 40px;}
    
	input[type="text"]{
	width: 240px;
	height: 40px;
	border:thin solid #eee;
	 }
	 
	 input[type="date"]{
	width: 240px;
	height: 40px;
	 }
	 
	 input[type="radio"] {
	 vertical-align:middle;
	 color:#a7a7a7;
	 border:thin solid #e9efed;
	 }
	 
	.buttonBox{
		margin-left:auto; 
		margin-right:auto; 
		margin-top:60px;
		width: 420px; 
	}
	
	
</style>
</head>

<body leftmargin="15">

<h1>인사/급여 데이터 </h1>
<hr>
<div class="formContent" style="margin-top: 50px;">
	<span></span>
	<form name="form1" id="form1" method="post" >
	
		<table>
			<tr >
				<th>귀속년월</th>
				<td>
					<select name="st_year">
                        <%for(int i=2022; i<=year; i++){%>
                        <option value="<%=i%>" <%if(st_year == i){%>selected<%}%>><%=i%>년</option>
                        <%}%>
                      </select> <select name="st_mon">
                        <%for(int i=1; i<=12; i++){%>
                        <option value="<%=i%>" <%if(st_mon == i){%>selected<%}%>><%=i%>월</option>
                        <%}%>
                      </select>					
				</td><br/>
			</tr>
		
		
		</table>
	</form>
</div>

<div class="buttonBox">
	
	<span>
		<button id="button"  style="margin-top:10px; "onclick="make_plit();">급여 연동데이터 생성</button>
	</span>
	
	<span>
		<button id="button1"  style="margin-top:10px; "onclick="make_plit1();">사업/기타 연동데이터 생성</button>
	</span>
	
</div>
</body>
</html>

