<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*" %>

<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//사용자별 정보 조회 및 수정 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String byear = request.getParameter("byear")==null?Util.getDate().substring(0,4):request.getParameter("byear");
	String bgubun = request.getParameter("bgubun")==null?"01":request.getParameter("bgubun");
	
	String user_nm = "";
	String enter_dt = "";
	String out_dt = "";
	
	int prv = 0;
	int jan = 0;
	int feb = 0;
	int mar = 0;
	int apr = 0;
	int may = 0;
	int jun = 0;
	int jul = 0;
	int aug = 0;
	int sep = 0;
	int oct = 0;
	int nov = 0;
	int dec = 0;
	int jan1 = 0;
	int feb1 = 0;
	int mar1 = 0;
	int apr1 = 0;
	int may1 = 0;
	int jun1 = 0;
	int jul1 = 0;
	int aug1 = 0;
	int sep1 = 0;
	int oct1 = 0;
	int nov1 = 0;
	int dec1 = 0;

	int count = 0;
		
	//사용자 정보 조회
	BudgetBean bean 	= CardDb.getUserBudget(user_id, byear, bgubun );

	user_nm = bean.getUser_nm();
	enter_dt = bean.getEnter_dt();
	out_dt = bean.getOut_dt();
	
	prv 	= bean.getPrv();
	jan 	= bean.getJan(); //회식비
	feb 	= bean.getFeb();
	mar 	= bean.getMar();
	apr 	= bean.getApr();
	may 	= bean.getMay();
	jun 	= bean.getJun();
	jul 	= bean.getJul();
	aug 	= bean.getAug();
	sep 	= bean.getSep();
	oct 	= bean.getOct();
	nov 	= bean.getNov();
	dec 	= bean.getDec();
	jan1 	= bean.getJan1(); //포상비 (장기근속등)
	feb1 	= bean.getFeb1();
	mar1 	= bean.getMar1();
	apr1 	= bean.getApr1();
	may1 	= bean.getMay1();
	jun1 	= bean.getJun1();
	jul1 	= bean.getJul1();
	aug1 	= bean.getAug1();
	sep1 	= bean.getSep1();
	oct1 	= bean.getOct1();
	nov1 	= bean.getNov1();
	dec1 	= bean.getDec1();

%>

<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	//수정
	function UserUp(){
		var theForm = document.form1;
		if(!confirm('수정하시겠습니까?')){ return; }
		theForm.cmd.value= "u";
		theForm.target="i_no";
		theForm.submit();
	}
	
//-->
</script>
</head>
<body  onLoad="self.focus()">
<center>
<form action="./user_null_ui.jsp" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">  
  <input type="hidden" name="bgubun" value="<%=bgubun%>">  
  <input type="hidden" name="cmd" value="">
  <table border=0 cellspacing=0 cellpadding=0 width=500>
  	<tr>
		<td colspan=3>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 법인전표관리 > <span class=style5>사용자예산수정</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>  
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
      <td class=line>
        <table border="0" cellspacing="1" width=500>
            <tr>
			  <td class=title>이름</td>
			  <td colspan=3>&nbsp;<input type="text" name="user_nm" value="<%=user_nm%>" size="10" class=text readonly ></td>			    	
             
           	</tr>
            <tr>
			  <td class=title>입사일</td>
			  <td>&nbsp;<input type="text" name="enter_dt" value="<%=enter_dt%>" size="10" class=text readonly ></td>			    	
              <td class=title>퇴사일</td>
	    	<td>&nbsp;<input type="text" name="out_dt" value="<%=out_dt%>" size="10" class=text readonly ></td>		    
           	</tr>
         	<tr>
			  <td class=title>예산년도</td>
			  <td>&nbsp;<input type="text" name="byear" value="<%=byear%>" size="10" class=text readonly ></td>	    	
              <td class=title>이월</td>
	    	<td>&nbsp;<input type="text" name="prv" value="<%=prv%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '></td>		    
           	</tr>
           	
           	<tr>
		      <td class=title>1월</td>
		      <td>&nbsp;<input type="text" name="jan" value="<%=jan%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      &nbsp;<input type="text" name="jan1" value="<%=jan1%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      </td>
		      <td class=title>2월</td>
		      <td>&nbsp;<input type="text" name="feb" value="<%=feb%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      &nbsp;<input type="text" name="feb1" value="<%=feb1%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      </td>
           	</tr>
           	<tr>
		      <td class=title>3월</td>
		      <td>&nbsp;<input type="text" name="mar" value="<%=mar%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      &nbsp;<input type="text" name="mar1" value="<%=mar1%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      </td>
		      <td class=title>4월</td>
		      <td>&nbsp;<input type="text" name="apr" value="<%=apr%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      &nbsp;<input type="text" name="apr1" value="<%=apr1%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      </td>
           	</tr>    
           	<tr>
		      <td class=title>5월</td>
		      <td>&nbsp;<input type="text" name="may" value="<%=may%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      &nbsp;<input type="text" name="may1" value="<%=may1%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      </td>
		      <td class=title>6월</td>
		      <td>&nbsp;<input type="text" name="jun" value="<%=jun%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      &nbsp;<input type="text" name="jun1" value="<%=jun1%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      </td>
           	</tr>
           	<tr>
		      <td class=title>7월</td>
		      <td>&nbsp;<input type="text" name="jul" value="<%=jul%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      &nbsp;<input type="text" name="jul1" value="<%=jul1%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      </td>
		      <td class=title>8월</td>
		      <td>&nbsp;<input type="text" name="aug" value="<%=aug%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      &nbsp;<input type="text" name="aug1" value="<%=aug1%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      </td>
           	</tr>      
           	<tr>
		      <td class=title>9월</td>
		      <td>&nbsp;<input type="text" name="sep" value="<%=sep%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      &nbsp;<input type="text" name="sep1" value="<%=sep1%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      </td>
		      <td class=title>10월</td>
		      <td>&nbsp;<input type="text" name="oct" value="<%=oct%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      &nbsp;<input type="text" name="oct1" value="<%=oct1%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      </td>
           	</tr>
           	<tr>
		      <td class=title>11월</td>
		      <td>&nbsp;<input type="text" name="nov" value="<%=nov%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      &nbsp;<input type="text" name="nov1" value="<%=nov1%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      </td>
		      <td class=title>12월</td>
		      <td>&nbsp;<input type="text" name="dec" value="<%=dec%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      &nbsp;<input type="text" name="dec1" value="<%=dec1%>" size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '>
		      </td>
           	</tr>     	
          </table>
        </td>
      </tr>
      
      <tr>
        <td>
          <table border="0" cellspacing="3" width=500>
            <tr>
			  <td align="right">

		        <a href="javascript:UserUp()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>

 		        &nbsp;<a href="javascript:self.close();window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
			  </td>
			</tr>
          </table>
       </td>
    </tr>
  </table>
</form>

</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>