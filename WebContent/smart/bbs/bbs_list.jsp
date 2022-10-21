<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" /> 

<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta name="robots" content="noindex, nofollow">

<style type="text/css">

/* body ���� �Ӽ� */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '�������';}
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0;}

/* ���̾ƿ� ū�ڽ� �Ӽ� */
#wrap {float:left; margin:0 auto; width:100%; background-color:#ffffff;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%;}
#footer {float:left; width:100%; height:50px; background:#C3C3C3; margin-top:20px;}

/* �޴������ܵ� */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* �ΰ� */
#gnb_box {float:left; text-align:middle; width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}

/* �˻�â */
#search fieldset {padding:0 0 15px 0; border:0px;}
#search .userform {width:100%; overflow:hidden; position:relative;}
#search .userform .name {float:left; position:absolute; width:100px; margin:5px 20px 0 20px;}
#search .userform .userinput {padding-right:60px; height:50px; margin:0 20px 0 85px;}
#search .userform .userinput input.text {border:1px solid #c9c9c9; width:100%; height:23px; font-weight:bold; font-size:0.95em; vertical-align:top;}
#search .userform .submit {float:left; position:absolute; right:0; top:0; padding-right:25px;}

.srch{width:100%;padding:5px 0}
.srch legend{overflow:hidden;visibility:hidden;position:absolute;top:0;left:0;width:1px;height:1px;font-size:0;line-height:0}
.srch{color:#c4c4c4;text-align:center}
.srch select,.srch input{margin:-1px 0 1px;font-size:12px;color:#373737;vertical-align:middle}
.srch .keyword{margin-left:1px;padding:2px 3px 5px;border:1px solid #b5b5b5;font-size:12px;line-height:15px}


/* ����Ʈ */
.search_list {width:100%; text-align:center; border-bottom:2px solid #b0baec; border-collapse:collapse;}
.search_list caption {display:none;}
.search_list th {padding:7px 0 4px 0; background-color:#e2e7ff; border-top:2px solid #b0baec; border-left:1px solid #b0baec; border-right:1px solid #b0baec; border-bottom:1px solid #b0baec; font-size:14px; font-family:NanumGothic, '�������'; font-weight:bold; color:#666666;}
.search_list td {padding:6px 0 4px 0; border:1px solid #b0baec; color:#4C4C4C#  font-size:14px; font-family:NanumGothic, '�������';}

#contentsWrap { padding:0; font-size:22px; } /* padding _ top bottom */
#topListWrap { position: relative; height: 100%; }
.List li {padding:0 21px;border-bottom:1px #eaeaea solid;  font-size:14px;}
.List li a {width:100%;padding:13px 0 6px 0;font-size:17px; color:#000;font-weight:bold; line-height:20px;font-weight:bold;display:block; text-decoration:none;}
.List li a em {color:#888;font-size:16px;}

</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*"%>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>
<%@ include file="/smart/cookies.jsp" %> 

<%
	String gubun = request.getParameter("gubun")==null?"c_mon":request.getParameter("gubun");
	
	OffAncDatabase oad = OffAncDatabase.getInstance();
	AncBean a_r [] = oad.getAncAll2( gubun,  t_wd,  gubun1,  ck_acar_id);
%>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/smart/include/common.js'></script>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		if(fm.t_wd.value == ''){ alert('�˻�� �Է��Ͻʽÿ�.'); fm.t_wd.focus(); return; }	
		fm.submit();
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
		
 	//���� ����
	function view_bbs(bbs_id){
		var fm = document.form1;
		fm.bbs_id.value = bbs_id;
		fm.action = 'bbs_info.jsp';
		fm.submit();
	}		
//-->
</script>

</head>

<body onload="document.form1.t_wd.focus()">

<table width=100% border=0 cellspacing=0 cellpadding=0>

<form name="form1" method="post"   action='bbs_list.jsp'>
	<input type='hidden' name="s_width" 	value="<%=s_width%>">   
	<input type='hidden' name="s_height" 	value="<%=s_height%>">     
	<input type='hidden' name="sh_height" 	value="<%=sh_height%>">   
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' 		value='<%=br_id%>'>
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>  
	<input type='hidden' name='bbs_id' 		value=''>
<div id="wrap">
	<div id="header">
        <div id="gnb_box">
        	
            <div id="gnb_login">��������</div>
            <div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
        </div>
    </div>
	<div id="contents">    
    	<div id="search">
			<fieldset class="srch">
				<legend>�˻�����</legend>
				<select name="gubun"> 
	            	<option value=""  		<% if(gubun.equals("")) out.print("selected"); %>>��ü</option>
	                <option value="c_mon"  <% if(gubun.equals("c_mon")) out.print("selected"); %>>���</option>
	                <option value="c_year"  <% if(gubun.equals("c_year")) out.print("selected"); %>>����</option>					
					<option value="title"	<% if(gubun.equals("title")) out.print("selected"); %>>����</option>
					<option value="content" <% if(gubun.equals("content")) out.print("selected"); %>>����</option>
					<option value="user_nm" <% if(gubun.equals("user_nm")) out.print("selected"); %>>�ۼ���</option>					  																		
				</select>
				<input accesskey="s" class="keyword" title=�˻��� type="text" name="t_wd" value="<%=t_wd%>"> 
				<input alt=�˻� src="/smart/images/btn_srch.gif" type="image"> 
			</fieldset> 
		</div>  
		<tbody>            
         <%
		
			if( a_r.length >0){
												
				for(int i=0; i < a_r.length; i++){
				  a_bean = a_r[i];
			%>
                
                 <ul class="List">
	               	  <li><a href="bbs_info.jsp?bbs_id=<%=a_bean.getBbs_id()%>" title='��������'>
	               	 	 <span>
	               	 		<%if(a_bean.getRead_yn().equals("Y")){%><img src="/smart/images/n_icon.gif" border=0 align=absmiddle />&nbsp;<%}%>
		                 	<%if(a_bean.getBbs_st().equals("1")){%>
							<font color="#990000">[�Ϲݰ���]</font>
							<%}else if(a_bean.getBbs_st().equals("2")){%>
							<font color="#990000">[�ֱٴ���]</font>
							<%}else if(a_bean.getBbs_st().equals("3")){%>
							<font color="#990000">[�Ǹ�����]</font>
							<%}else if(a_bean.getBbs_st().equals("4")){%>
							<font color="#990000">[��������]</font>
							<%}else if(a_bean.getBbs_st().equals("5")){%>
							<font color="#990000">[������]</font>
							<%}else if(a_bean.getBbs_st().equals("6")){%>
							<font color="#990000">[�������λ�]</font>
							<%}%>
							 <%=a_bean.getTitle()%>&nbsp;</span></a>				 							 
					 <span><font color='#3b44bb'><b>
					 <%=a_bean.getUser_nm()%></b>&nbsp;|&nbsp;<%=a_bean.getReg_dt()%></font>&nbsp;</span><br />
					 <div style="height:7px;"></div>
		    		 <span>
		    			<%=Util.subData(a_bean.getContent(),70)%>&nbsp;</span><br> 		    		
		    		<div style="height:10px;"></div>
		    		 </li>													    		
    			</ul>	    			
             	
                <% if(i == (a_r.length  - 1)) break;
							  	}//for
							}else{ %>
                            <span>����Ÿ�� �����ϴ�.</span><br> 		
                            
                <% } %> 
               <div style="height:10px;"></div>         
        </tbody>               
	 </div>   
</div>	    
</form>
</body>
</html>