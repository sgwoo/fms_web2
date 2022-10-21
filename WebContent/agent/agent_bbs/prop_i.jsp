<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.off_anc.*" %>
<%@ page import="acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//등록자
	UsersBean user_bean = umd.getUsersBean(user_id);
%>
<html>
<head><title>FMS</title>
<script language="JavaScript" src="../../include/common.js"></script>
<script language='javascript'>
<!--
//등록
function AncReg()
{
	var fm = document.form1;
	
	if(fm.title.value == '')						{	alert('제목을 입력하십시오');			fm.title.focus(); 		return;	}
	else if(fm.content1.value == '')				{	alert('문제점을 입력하십시오');			fm.content1.focus(); 	return;	}
	else if(fm.content2.value == '')				{	alert('개선안을 입력하십시오');			fm.content2.focus(); 	return;	}
	else if(fm.content3.value == '')				{	alert('기대효과를 입력하십시오');		fm.content3.focus(); 	return;	}
	
	if(get_length(fm.title.value) > 300 ) 			{	alert("제목은 300자 까지만 입력할 수 있습니다.");				return;	}
	else if(get_length(fm.content1.value) > 4000)	{	alert("문제점은 4000자 까지만 입력할 수 있습니다.");			return;	}
	else if(get_length(fm.content2.value) > 4000)	{	alert("개선안은 4000자 까지만 입력할 수 있습니다.");			return;	}
	else if(get_length(fm.content3.value) > 4000)	{	alert("기대효과는 4000자 까지만 입력할 수 있습니다.");			return;	}
				
	fm.cmd.value = "i";

	if(confirm('등록하시겠습니까?')){
		//document.domain = "amazoncar.co.kr";
		fm.action='prop_null_ui.jsp';		
		fm.target="i_no";
		fm.submit();
	}
	
}

//길이점검
function get_length(f) {
	var max_len = f.length;
	var len = 0;
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
	}
	return len;
}

//목록
function go_to_list()
{
	var fm = document.form1;
	fm.action = "./prop_s_frame.jsp";
	fm.target = 'd_content';
	fm.submit();
}	

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form  name="form1" method="post" >
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='asc'	 	value='<%=asc%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>      
  <input type="hidden" name="cmd" value="">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">  
  <input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>"> 
   <input type='hidden' name="public_yn" value="Y"> <!-- 외부업체는 무조건 공개 --> 
<table border="0" cellspacing="0" cellpadding="0" width=800>
  <tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>MASTER > 제안함 > <span class=style5> 
						제안함 등록
						</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
  	
	<tr>
	  <td colspan='4' align='right'> <a href="javascript:go_to_list()"><img src="/acar/images/center/button_list.gif"  aligh="absmiddle" border="0"> </a></td>
	</tr>
	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>
	  <td class='line'>
		<table border="0" cellspacing="1" cellpadding="0" width=800>			
		  <tr>
			<td width="70" class="title">작성자</td>
			<td width="330" align="center"><%=user_bean.getUser_nm()%>&nbsp;&nbsp;&nbsp;<input type="checkbox" name="open_yn" value="Y" checked >실명공개</td>
			<td width="70" class="title"><div align="center">부서</div></td>
			<td width="330" align="center"><div align="center"><%=user_bean.getDept_nm()%></div></td>	
		  </tr>
		 <!-- 
		   <tr>
			<td width="70" class="title">공개범위</td>
			<td colspan="3" align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="public_yn" value="Y"  >외부(협력업체/에이전트)포함 공개</td>
		  </tr> -->
		  <tr>
			<td width="70" class="title">제목</td>
			<td colspan="3" align="center"><input type='text' name="title" id="title" size='112' class='text' style='IME-MODE: active'></td>
		  </tr>
		  <tr>
			<td width="70" class="title">문제점</td>
		    <td colspan="3" align="center"><textarea name="content1" id="content1" cols='110' rows='10'></textarea></td>
		  </tr>
		  <tr>
			<td width="70" class="title">개선안</td>
		    <td colspan="3" align="center"><textarea name="content2" id="content2" cols='110' rows='10'></textarea></td>
		  </tr>
		  <tr>
			<td width="70" class="title">기대효과</td>
			<td colspan="3" align="center"><textarea name="content3" id="content3" cols='110' rows='8'></textarea></td>
		  </tr>
		</table>		
	  </td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td class=h ><font color=red>***</font>&nbsp;문서첨부는 등록후 수정을 통해서 등록하세요. </td>
	</tr>
	
    <tr>
	  <td colspan='4' align='right'>
	    <a href="javascript:AncReg()"><img src="/acar/images/center/button_reg.gif"  aligh="absmiddle" border="0"></a>&nbsp;&nbsp;
		<a href='javascript:document.form1.reset();' onMouseOver="window.status=''; return true" ><img src="/acar/images/center/button_cancel.gif"  aligh="absmiddle" border="0"> </a>
	  </td>
	</tr>
  </table>
</form>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script>
	// 특수문자 제한	2018.01.09		'와 "만 제한하기로 변경 2018.02.06
	var regex = /['"]/gi;
	var title;
	var content1;
	var content2;
	var content3;
	
	$("#title").bind("keyup",function(){title = $("#title").val();if(regex.test(title)){$("#title").val(title.replace(regex,""));}});	// 제목
	$("#content1").bind("keyup",function(){content1 = $("#content1").val();if(regex.test(content1)){$("#content1").val(content1.replace(regex,""));}});	// 문제점
	$("#content2").bind("keyup",function(){content2 = $("#content2").val();if(regex.test(content2)){$("#content2").val(content2.replace(regex,""));}});	// 개선안
	$("#content3").bind("keyup",function(){content3 = $("#content3").val();if(regex.test(content3)){$("#content3").val(content3.replace(regex,""));}});	// 기대효과
</script>
<iframe src="about:blank" name="i_no" width="0" height="0"  frameborder="0" noresize> </iframe>
</body>
</html>