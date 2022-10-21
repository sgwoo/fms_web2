<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.call.*"%>
<jsp:useBean id="p_db" class="acar.call.PollDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String poll_id = request.getParameter("poll_id")==null?"0":request.getParameter("poll_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "06", "02");
	
	String question = "";
	String answer1 = "";
	String answer2 = "";
	String answer3 = "";
	String answer4 = "";
	String answer5 = "";
	String answer6 = "";
	String answer7 = "";
	String answer8 = "";
	String answer9 = "";
	String answer10 = "";
	String use_yn = "";
	String answer1_rem = "";
	String answer2_rem = "";
	String answer3_rem = "";
	String answer4_rem = "";
	String answer5_rem = "";
	String answer6_rem = "";
	String answer7_rem = "";
	String answer8_rem = "";
	String answer9_rem = "";
	String answer10_rem = "";
	String poll_st = "";
	String poll_type = "";
	int    poll_seq = 0;

	int count = 0;
	
	if(!poll_id.equals("0"))
	{
				
		LivePollBean bean = p_db.getPollBean(poll_id);
		
		question = bean.getQuestion();
		answer1 = bean.getAnswer1();
		answer2 = bean.getAnswer2();
		answer3 = bean.getAnswer3();
		answer4	= bean.getAnswer4();
		answer5 = bean.getAnswer5();
		answer6 = bean.getAnswer6();
		answer7 = bean.getAnswer7();
		answer8 = bean.getAnswer8();
		answer9 = bean.getAnswer9();
		answer10 = bean.getAnswer10();
		use_yn = bean.getUse_yn();
		answer1_rem = bean.getAnswer1_rem();
		answer2_rem = bean.getAnswer2_rem();
		answer3_rem = bean.getAnswer3_rem();
		answer4_rem	= bean.getAnswer4_rem();
		answer5_rem = bean.getAnswer5_rem();
		answer6_rem = bean.getAnswer6_rem();
		answer7_rem = bean.getAnswer7_rem();
		answer8_rem = bean.getAnswer8_rem();
		answer9_rem = bean.getAnswer9_rem();
		answer10_rem = bean.getAnswer10_rem();
		poll_st = bean.getPoll_st();
		poll_seq = bean.getPoll_seq();
		poll_type = bean.getPoll_type();
	
	}
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function Save(idx){
		var fm = document.form1;
		if(!CheckField()){	return;	}
	
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		fm.cmd.value= "u";
			
		fm.target="i_no";
		fm.submit();
	}

	function CheckField(){
		var fm = document.form1;		
		if(fm.question.value==""){		alert("���������� �Է��Ͻʽÿ�.");			fm.question.focus();		return false;	}
		if(fm.answer1.value==""){		alert("���1 �Է��Ͻʽÿ�.");	fm.answer1.focus();	return false;	}
//		if(fm.answer2.value==""){		alert("���2 �Է��Ͻʽÿ�.");	fm.answer2.focus();	return false;	}
		return true;
	}
	
	function go_to_list()
	{
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
	
		location='/acar/call/poll_s_frame.jsp?auth_rw='+auth_rw;
	}	
//-->
</script>
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
<body  onLoad="document.form1.question.focus()">
<center>
<form action="poll_null_ui.jsp" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>"> 
  <input type="hidden" name="user_id" value="<%=user_id%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="poll_id" value="<%=poll_id%>">   
  <input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�ݼ��� > ���׸���� > <span class=style5>���׸���</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>      
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
             <tr>
                    <td class='title'>�ݱ���</td>
                    <td colspan='3' class=b>&nbsp;
                      <select name='poll_type'>
                       	<option value="1" <%if(poll_type.equals("1")){%>selected<%}%>>���</option>
                        <option value="2" <%if(poll_type.equals("2")){%>selected<%}%>>��ȸ����</option>
                        <option value="3" <%if(poll_type.equals("3")){%>selected<%}%>>���ó��</option>
                    
                      </select></td>                    
                </tr>
                <tr>
                    <td class='title'>������ȭŸ��</td>
                    <td colspan='3' class=b>&nbsp;
                      <select name='poll_st'>
                      	<option value="" <%if(poll_st.equals("")){%>selected<%}%>>-����-</option>
                      	<option value="1" <%if(poll_st.equals("1")){%>selected<%}%>>�ű�</option>
                        <option value="3" <%if(poll_st.equals("3")){%>selected<%}%>>����</option>
                        <option value="4" <%if(poll_st.equals("4")){%>selected<%}%>>����</option>
                        <option value="5" <%if(poll_st.equals("5")){%>selected<%}%>>����</option>
                        <option value="6" <%if(poll_st.equals("6")){%>selected<%}%>>�縮��(�ű�)</option>
                        <option value="8" <%if(poll_st.equals("8")){%>selected<%}%>>�縮��(����)</option>
                      </select></td>                    
                </tr>
                <tr>
                    <td class='title' width=12%>��������</td>
                    <td colspan='3' align='left' width=88% class=b>&nbsp;
                    <input type='text' name='question' size='100' maxlength='256'  value="<%=question%>" class='text' style='IME-MODE: active'>
                    </td>
                </tr>
                <tr>
                    <td class='title'>�亯 1</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                        <input type='text' name='answer1' size='100' maxlength='256' value="<%=answer1%>" class='text' style='IME-MODE: active'>
                        <input type='checkbox' name='answer1_rem'  <%if(answer1_rem.equals("1")){ %>checked<%}%>>�����������&nbsp;
                        
                    </td>
                </tr>
                <tr>
                    <td class='title'>�亯 2</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                        <input type='text' name='answer2' size='100' maxlength='256' value="<%=answer2%>" class='text' style='IME-MODE: active'>
                        <input type='checkbox' name='answer2_rem'  <%if(answer2_rem.equals("1")){ %>checked<%}%>>�����������&nbsp;
                          
                    </td>
                </tr>
                <tr>
                    <td class='title'>�亯 3</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                        <input type='text' name='answer3' size='100' maxlength='256' value="<%=answer3%>" class='text' style='IME-MODE: active'>
                        <input type='checkbox' name='answer3_rem'  <%if(answer3_rem.equals("1")){ %>checked<%}%>>�����������&nbsp;
                        
                    </td>
                </tr>
                <tr>
                    <td class='title'>�亯 4</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                        <input type='text' name='answer4' size='100' maxlength='256' value="<%=answer4%>" class='text' style='IME-MODE: active'>
                        <input type='checkbox' name='answer4_rem'  <%if(answer4_rem.equals("1")){ %>checked<%}%>>�����������&nbsp;
                          
                    </td>
                </tr>
                <tr>
                    <td class='title'>�亯 5</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                        <input type='text' name='answer5' size='100' maxlength='256' value="<%=answer5%>" class='text' style='IME-MODE: active'>
                        <input type='checkbox' name='answer5_rem'  <%if(answer5_rem.equals("1")){ %>checked<%}%>>�����������&nbsp;
                      
                    </td>
                </tr>
                <tr>
                    <td class='title'>�亯 6</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                        <input type='text' name='answer6' size='100' maxlength='256' value="<%=answer6%>" class='text' style='IME-MODE: active'>
                        <input type='checkbox' name='answer6_rem'  <%if(answer6_rem.equals("1")){ %>checked<%}%>>�����������&nbsp;
                            
                    </td>
                </tr>
                <tr>
                    <td class='title'>�亯 7</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                        <input type='text' name='answer7' size='100' maxlength='256' value="<%=answer7%>" class='text' style='IME-MODE: active'>
                        <input type='checkbox' name='answer7_rem'  <%if(answer7_rem.equals("1")){ %>checked<%}%>>�����������&nbsp;
                            
                    </td>
                </tr>
                <tr>
                    <td class='title'>�亯 8</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                        <input type='text' name='answer8' size='100' maxlength='256' value="<%=answer8%>" class='text' style='IME-MODE: active'>
                        <input type='checkbox' name='answer8_rem'  <%if(answer8_rem.equals("1")){ %>checked<%}%>>�����������&nbsp;
                        
                    </td>
                </tr>        
                  <tr>
                    <td class='title'>�亯 9</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                        <input type='text' name='answer9' size='100' maxlength='256' value="<%=answer9%>" class='text' style='IME-MODE: active'>
                        <input type='checkbox' name='answer9_rem'  <%if(answer9_rem.equals("1")){ %>checked<%}%>>�����������&nbsp;
                        
                    </td>
                </tr>          
                   <tr>
                    <td class='title'>�亯10</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                        <input type='text' name='answer10' size='100' maxlength='256' value="<%=answer10%>" class='text' style='IME-MODE: active'>
                        <input type='checkbox' name='answer10_rem'  <%if(answer10_rem.equals("1")){ %>checked<%}%>>�����������&nbsp;
                        
                    </td>
                </tr>          
                <tr>
                    <td class='title'>��뱸��</td>
                    <td colspan='3' class=b>&nbsp;
                    <select name='use_yn'>
                      	<option value="Y" <%if(use_yn.equals("Y")){%>selected<%}%>>���</option>
                        <option value="N" <%if(use_yn.equals("N")){%>selected<%}%>>�̻��</option>
                    </select></td>
                </tr>          
                <tr>
                    <td class='title'>����</td>
                    <td colspan='3' align='left' class=b>&nbsp;
                        <input type='text' name='poll_seq' size='10'  value="<%=poll_seq%>" class='text' style='IME-MODE: active'>               
                    </td>
                </tr>            
            </table>        
        </td>
    </tr>
    <tr>
        <td>
            <table border="0" cellspacing="3" width=100%>
                <tr>
			        <td align=center>
    			  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
    			     	<a href="javascript:Save('u')"><img src=../images/center/button_modify.gif border=0 align=absmiddle></a>
    			  <%}%>	
            		&nbsp;<a href="javascript:go_to_list()"><img src=../images/center/button_list.gif border=0 align=absmiddle></a></td>
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