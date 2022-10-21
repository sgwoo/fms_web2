<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "03", "01");
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save()
	{
		if(confirm('등록하시겠습니까?'))
		{
			var fm = document.form1;
			if(fm.question.value == ''){		alert('질문내용을 입력하십시오');	return;	}
			else if(fm.answer1.value == ''){	alert('대답1 입력하십시오');	return;	}
		//	else if(fm.answer2.value == ''){	alert('대답2 입력하십시오');	return;	}
				
			fm.target='i_no';
			fm.submit();
		}
	}

	
	function go_to_list()
	{
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
	
		location='/acar/call/poll_s_frame.jsp?auth_rw='+auth_rw;
	}	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
<body>
<form name='form1' method='post' action='/acar/call/poll_i_a.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>콜센터 > 콜항목관리 > <span class=style5>콜항목등록</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
                <tr>
                    
                </tr>
            </table>
    	</td>
    </tr>
<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	<tr>
		<td align='right'> <a href="javascript:save()"><img src="../images/center/button_reg.gif" align="absmiddle" border="0"></a>
		        <a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src="../images/center/button_list.gif" align="absmiddle" border="0"></a> 
		</td>
	</tr>	
<%	}%>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
	    <td class='line'>
		 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
               <tr>
                    <td class='title'>콜구분</td>
                    <td colspan='3' class=b>&nbsp;
                      <select name='poll_type'>
                        <option value='1' selected >계약</option>
                        <option value='2'>순회정비</option>
                        <option value='3'> 사고처리</option>
                    
                      </select></td>                
                </tr>
                <tr>
                    <td class='title'>감사전화타입</td>
                    <td colspan='3' class=b>&nbsp;
                      <select name='poll_st'>
                       <option value='' selected >-선택-</option>
                        <option value='1'>신규</option>
                        <option value='3'>대차</option>
                        <option value='4'>증차</option>
                        <option value='5'>연장</option>
                        <option value='6'>재리스(신규)</option>
                        <option value='8'>재리스(기존)</option>
                      </select></td>                
                </tr>
                <tr>
                    <td class='title' width=12%>질문내용</td>
                    <td colspan='3' align='left' width=88% class=b>&nbsp;
                        <input type='text' name='question' size='100' maxlength='256' class='text' style='IME-MODE: active'>
                    </td>
                </tr>
                <tr>
                    <td class='title'>답변 1</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                        <input type='text' name='answer1' size='100' maxlength='256' class='text' style='IME-MODE: active'>
                        <input type='checkbox' name='answer1_rem'  >별도설명허용
                    </td>
                </tr>
                <tr>
                    <td class='title'>답변 2</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                        <input type='text' name='answer2' size='100' maxlength='256' class='text' style='IME-MODE: active'>
                        <input type='checkbox' name='answer2_rem'  >별도설명허용
                    </td>
                </tr>
                <tr>
                    <td class='title'>답변 3</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                    <input type='text' name='answer3' size='100' maxlength='256' class='text' style='IME-MODE: active'>
                    <input type='checkbox' name='answer3_rem'  >별도설명허용
                    </td>
                </tr>
                <tr>
                    <td class='title'>답변 4</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                    <input type='text' name='answer4' size='100' maxlength='256' class='text' style='IME-MODE: active'>
                    <input type='checkbox' name='answer4_rem'  >별도설명허용
                    </td>
                </tr>
                <tr>
                    <td class='title'>답변 5</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                    <input type='text' name='answer5' size='100' maxlength='256' class='text' style='IME-MODE: active'>
                    <input type='checkbox' name='answer5_rem'  >별도설명허용
                    </td>
                </tr>
                <tr>
                    <td class='title'>답변 6</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                    <input type='text' name='answer6' size='100' maxlength='256' class='text' style='IME-MODE: active'>
                    <input type='checkbox' name='answer6_rem'  >별도설명허용
                    </td>
                </tr>
                <tr>
                    <td class='title'>답변 7</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                    <input type='text' name='answer7' size='100' maxlength='256' class='text' style='IME-MODE: active'>
                    <input type='checkbox' name='answer7_rem'  >별도설명허용
                    </td>
                </tr>
                <tr>
                    <td class='title'>답변 8</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                        <input type='text' name='answer8' size='100' maxlength='256' class='text' style='IME-MODE: active'>
                        <input type='checkbox' name='answer8_rem'  >별도설명허용
                    </td>
                </tr>           
                 <tr>
                    <td class='title'>답변 9</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                        <input type='text' name='answer9' size='100' maxlength='256' class='text' style='IME-MODE: active'>
                        <input type='checkbox' name='answer9_rem'  >별도설명허용
                    </td>
                </tr>           
                <tr>
                    <td class='title'>답변10</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                        <input type='text' name='answer10' size='100' maxlength='256' class='text' style='IME-MODE: active'>
                        <input type='checkbox' name='answer10_rem'  >별도설명허용
                    </td>
                </tr>           
                <tr>
                    <td class='title'>사용구분</td>
                    <td colspan='3' class=b>&nbsp;
                      <select name='use_yn'>
                        <option value='Y' selected >사용</option>
                        <option value='N'>미사용</option>
                      </select></td>
                </tr>       
                <tr>
                    <td class='title'>연번</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                    <input type='text' name='poll_seq' size='10'  class='text' style='IME-MODE: active'>                   
                    </td>
                </tr>
            </table>
	    </td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
