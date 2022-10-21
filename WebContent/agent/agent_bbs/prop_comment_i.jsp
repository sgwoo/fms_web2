<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="p_bean" class="acar.off_anc.PropBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%

	request.setCharacterEncoding("euc-kr");
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	int yn			= request.getParameter("yn") 	 ==null?0:Util.parseInt(request.getParameter("yn"));  // 추가
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	OffPropDatabase p_db = OffPropDatabase.getInstance();
	
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&asc="+asc+"&gubun1="+gubun1+"&gubun2="+gubun2+
					"&st_dt="+st_dt+"&end_dt="+end_dt;
	
	//접속자
	UsersBean user_bean = umd.getUsersBean(user_id);
	
	int prop_id = request.getParameter("prop_id")==null?0:Util.parseInt(request.getParameter("prop_id"));
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	int count1 = 0;
	int count2 = 0;
	int count3 = 0;

	
	p_bean = p_db.getPropBean(prop_id);
	
	PropCommentBean pc_r [] = p_db.getPropCommentList(prop_id);
%>
<html>
<head><title>FMS</title>
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--
//수정
function AncUp()
{
	var fm = document.form1;
	
	if(fm.content.value == '')						{	alert('의견을 입력하십시오');			fm.content.focus(); 	return;	}	
	if(get_length(fm.content.value) > 4000 ) 		{	alert("의견은 4000자 까지만 입력할 수 있습니다.");				return;	}
	
	if(fm.yn[0].checked == false && fm.yn[1].checked == false  && fm.yn[2].checked == false )	{ alert('찬반여부를 선택하십시오.'); return;}
				
	if(!confirm('등록하시겠습니까?'))
		return;		
			
	fm.cmd.value = "i";
	fm.target="i_no";
	fm.action = "./prop_comment_a.jsp";
	fm.submit();
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
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLp_db="javascript:self.focus()">
<form action="./prop_comment_a.jsp" name="form1" method="post">
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
  <input type="hidden" name="prop_id" 	value="<%=prop_id%>">
  <input type="hidden" name="mode" 		value="<%=mode%>">
  <input type="hidden" name="cmd" 		value="">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">  
  <input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>MASTER > 제안함 > <span class=style5> 
					의견 등록
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
		<td class=line2 ></td>
	</tr>
	<tr>
	  <td class='line'>
		<table border="0" cellspacing="1" cellpadding="0" width=100%>			
		  <tr>
			<td width=13% class="title">제안안</td>
			<td>&nbsp;<br>&nbsp;<%=p_bean.getTitle()%><br>&nbsp;</td>
		  </tr>			
		</table>
	  </td>
	</tr>
	<tr>		
      <td>&nbsp;</td>
	</tr>
	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>
	  <td class='line'>
		<table border="0" cellspacing="1" cellpadding="0" width=100%>					  						
		  <tr>
			<td width=15% class="title">작성자</td>
			<td>&nbsp;<%=user_bean.getUser_nm()%>&nbsp;&nbsp;&nbsp;<input type="checkbox" name="open_yn" value="Y" checked >실명공개</td>
			<td width=15% class="title">작성일</td>
			<td colspan="3">&nbsp;<%=AddUtil.getDate()%></td>
		  </tr>
		  	
		  <tr>
			<td class="title">의견구분</td>
			<td>
			  &nbsp;<select name="com_st" disabled>
			    <option value="1" <%if(mode.equals("1")){%>selected<%}%>>의견수렴</option>
			    <option value="2" <%if(mode.equals("2")){%>selected<%}%>>제안검토</option>
			    <option value="3" <%if(mode.equals("3")){%>selected<%}%>>최종안</option>				
  			  </select>
			</td>
			<td class="title">찬반여부</td>
			<td width=17% align="center">찬성 : <input type="radio" name="yn" value=0></td>
		    <td width=17% align="center">반대 : <input type="radio" name="yn" value=1></td>
		    <td width=17% align="center">기권 : <input type="radio" name="yn" value=2></td>
		  </tr>		    
		  <tr>
			<td class="title">의견</td>
		    <td colspan="5">
			  &nbsp;<textarea name="content" id="content" cols='67' rows='10' style='IME-MODE: active'></textarea></td>
		  </tr>
		</table>
	  </td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
	  <td align='right'> 
	    <a href="javascript:AncUp()" onMouseOver="window.status=''; return true"> <img src="/acar/images/center/button_reg.gif"  aligh="absmiddle" border="0"></a> &nbsp;		
	    <a href="javascript:window.close()" onMouseOver="window.status=''; return true"> <img src="/acar/images/center/button_close.gif"  aligh="absmiddle" border="0"></a> &nbsp;
	  </td>
	</tr>	
  </table>
</form>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script>
	//특수문자 제한	2018.01.09		'와 "만 제한하기로 변경 2018.02.06
	var regex = /['"]/gi;
	var content;
	$("#content").bind("keyup",function(){content = $("#content").val();if(regex.test(content)){$("#content").val(content.replace(regex,""));}});	// 의견
</script>
<iframe src="about:blank" name="i_no" width="100" height="100"  frameborder="0" noresize> </iframe>
</body>
</html>