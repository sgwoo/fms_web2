<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS Client_Info</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<meta name="viewport" content="width=device-width,height=device-height,user-scalable=yes,initial-scale=1.0;"> 
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
#wrap {float:left; margin:0 auto; width:100%; background-color:#dedbcd;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%; height:100%}
#footer {float:left; width:100%; height:40px; background:#44402d; margin-top:40px;}

/* �޴������ܵ� */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* �ΰ� */
#gnb_box {float:left; text-align:middle; width:100%; height:40Px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}



.view_detail {width:100%; border-bottom:1px solid #DDDEE2; table-layout:fixed; font:12px;}
.view_detail th {padding:8px 0 5px 10px; width:25%; border-top:1px solid #DDDEE2; background:#F1F1F3; color:#3333cc; font-weight:bold; text-align:left; vertical-align:top;}
.view_detail td {padding:8px 5px 5px 10px; border-top:1px solid #DDDEE2; line-height:16px; vertical-align:top;}


/* �ձ����̺� ���� */

.roundedBox {position:relative; width:83%; padding:17px; }

    .corner {position:absolute; width:17px; height:17px;}

        .topLeft {top:0; left:0; background-position:-1px -1px;}
        .topRight {top:0; right:0; background-position:-19px -1px;}
        .bottomLeft {bottom:0; left:0; background-position:-1px -19px;}
        .bottomRight {bottom:0; right:0; background-position:-19px -19px;}
        
#type4 {background-color:#fff; border:1px solid #bcb9aa;}
    #type4 .corner {background-image:url(/smart/images/corners-type.gif);}
        #type4 .topLeft {top:-1px;left:-1px;}
        #type4 .topRight {top:-1px; right:-1px;}
        #type4 .bottomLeft {bottom:-1px; left:-1px;}
        #type4 .bottomRight {bottom:-1px; right:-1px;}





/* �������̺� */
.contents_box {width:100%; table-layout:fixed; font-size:13px;}
.contents_box th {color:#282828; height:26px; text-align:left; font-weight:bold;}
.contents_box td {line-height:16px; color:#7f7f7f; font-weight:bold;}


/* �������̺� */
#ctitle {float:left; margin:3px 0 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:15px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}
#cbtn { text-align:center; margin:15px 0 0 0;}




</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.* "%>
<%@ page import="acar.client.*, acar.cus0402.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="c42_cvBn" class="acar.cus0402.Cycle_vstBean" scope="page"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	Cus0402_Database c42_db = Cus0402_Database.getInstance();
	
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String seq 			= request.getParameter("seq")==null?"":request.getParameter("seq");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	
	//������
	ClientBean client = al_db.getNewClient(client_id);
	
	//��ȸ�湮-�ŷ�ó
	Cycle_vstBean[] cvBns = c42_db.getCycle_vstList(client_id);
	
	Cycle_vstBean cvBn = c42_db.getCycle_vstList(client_id, seq);
%>

<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//������ã��
	function search_cust(){
		var fm = document.form1;
		var SUBWIN="search_cust_list.jsp?t_wd=";		
		window.open(SUBWIN, "SubCust", "left=100, top=100, width=600, height=400, scrollbars=yes, status=yes");		
	}
	
	//����ϱ�
	function VstReg(){
		var fm = document.form1;
		
		if(fm.client_id.value == ''){ alert('���� ��ȸ�Ͻʽÿ�'); return; }				
		if(fm.vst_dt.value == '')	{ alert('�湮���ڸ� �Է��Ͻʽÿ�'); return; }
		<%if(seq.equals("")){%>
		if(fm.vst_pur.value == '')	{ alert('�湮������ �����Ͻʽÿ�'); return; }
		if(fm.vst_pur.value == '6' && fm.vst_title.value == '')	{ alert('��Ÿ �湮������ �Է��Ͻʽÿ�'); return; }				
		fm.vst_pur_nm.value = fm.vst_pur.options[fm.vst_pur.selectedIndex].text;
		<%}else{%>
		if(fm.vst_title.value == '')	{ alert('�湮������ �Է��Ͻʽÿ�'); return; }						
		<%}%>
		
		<%if(seq.equals("")){%>
			if(!confirm('����Ͻðڽ��ϱ�?')){	return; }
			fm.cmd.value = "i";
		<%}else{%>
			if(!confirm('�����Ͻðڽ��ϱ�?')){	return; }
			fm.cmd.value = "u";
		<%}%>
		fm.action = 'client_vst_reg_a.jsp';

		fm.target = "i_no";
		fm.submit();
	
	}
	
	function date_type_input(date_type){
		var fm = document.form1;
		var today = new Date();
		var s_dt = "";		
		var dt = today;
		if(date_type==1){//����			
			dt = new Date(today.valueOf()+(24*60*60*1000));
		}else if(date_type == -1){
			dt = new Date(today.valueOf()-(24*60*60*1000)*1);
		}else if(date_type == -2){
			dt = new Date(today.valueOf()-(24*60*60*1000)*2);
		}
		s_dt = String(dt.getFullYear())+"-";
		if(dt.getFullYear()<2000) s_dt = String(dt.getFullYear()+1900)+"-";		
		if((dt.getMonth()+1) < 10) 	s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getMonth()+1)+"-";
		if(dt.getDate() < 10) 		s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getDate());
		
		fm.vst_dt.value = s_dt;		
	}			
	
	function page_reload()
	{
		var fm = document.form1;		
		fm.action = "client_vst_reg.jsp";		
		fm.target = "_self";
		fm.submit();
	}	
	
	function view_vst(seq)
	{
		var fm = document.form1;		
		if(seq == ''){
			fm.action = "/smart/fms/client_vst_list.jsp";	
		}else{
			fm.seq.value = seq;
			fm.action = "client_vst_view.jsp";	
		}
		fm.target = "_self";
		fm.submit();
	}					
		
	function view_before()
	{
		var fm = document.form1;	
		<%if(seq.equals("")){%>	
		fm.action = "nreg_main.jsp";	
		<%}else{%>
		fm.action = "client_vst_view.jsp";	
		<%}%>
		fm.target = "_self";	
		fm.submit();
	}			
//-->
</script>

<body>
<form name='form1' method='post' action=''>
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='client_id' 	value='<%=client_id%>'>
	<input type='hidden' name='firm_nm' 	value='<%=firm_nm%>'>
	<input type='hidden' name='seq' 		value='<%=seq%>'>	
	<input type='hidden' name='cmd' 		value=''>		
	<input type='hidden' name='vst_pur_nm'	value=''>		
	<input type='hidden' name='from_page'	value='client_vst_reg.jsp'>	

	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">�ŷ�ó�湮<%if(seq.equals("")){%>���<%}else{%>����<%}%></div>
			<div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='����ȭ�� ����'><img src=/smart/images/button_back.gif align=absmiddle /></a>
				<a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>            
        </div>
    </div>
    <div id="contents">
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">������&nbsp;
		<%if(seq.equals("")){%>
		<a href="javascript:search_cust()" onMouseOver="window.status=''; return true" title="����ȸ�ϱ�. Ŭ���ϼ���"><img src="/smart/images/btn_serch.gif"  border="0" align=absmiddle></a>
		<%}%>
		</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width="90" valign=top>��ȣ/����</th>
							<td valign=top><font color=#fd5f00><%=client.getFirm_nm()%></font></td>
						</tr>
						<%if(client.getClient_st().equals("1")){%>
						<tr>
							<th valign=top>��ǥ��</th>
							<td valign=top><%=client.getClient_nm()%></td>
						</tr>
						<%}%>
						<tr>
							<th valign=top>������ּ�</th>
							<td valign=top><%=client.getO_zip()%> <%=client.getO_addr()%></td>
						</tr>
						<%if(seq.equals("")){%>
						<tr>
							<th valign=top>��ȭ(�繫��)</th>
							<td valign=top><a href="tel:<%=AddUtil.phoneFormat(client.getO_tel())%>"><font color=#fd5f00><%=AddUtil.phoneFormat(client.getO_tel())%></font></a></td>
						</tr>
						<tr>
							<th valign=top>��ȭ(����)</th>
							<td valign=top><a href="tel:<%=AddUtil.phoneFormat(client.getH_tel())%>"><font color=#fd5f00><%=AddUtil.phoneFormat(client.getH_tel())%></font></a></td>
						</tr>
						<tr>
							<th valign=top>�޴��ȣ</th>
							<td valign=top><a href="tel:<%=AddUtil.phoneFormat(client.getM_tel())%>"><font color=#fd5f00><%=AddUtil.phoneFormat(client.getM_tel())%></font></a></td>
						</tr>
						<%}%>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<%if(seq.equals("")){%>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">�ֱٹ湮����&nbsp;</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<%	int cv_size = cvBns.length;
							if(cv_size>3) cv_size=3;
							for(int j=0; j<cv_size; j++){
								c42_cvBn = cvBns[j];%>		
				    	<tr>
				    		<th width="70"><a href="javascript:view_vst('<%=c42_cvBn.getSeq()%>');"><%=c42_cvBn.getVst_dt()%></a></th>
				    		<td><%=c_db.getNameById(c42_cvBn.getVisiter(),"USER")%> [<%=c42_cvBn.getVst_title()%>] </td>
				    	</tr>
						<%	}%>
						<%	if(cvBns.length>3){%>
						<tr>
							<th></th>
							<td align="right"><a href="javascript:view_vst('');">[more]</a>
							</td>
						</tr>
						<%	}%>
						<%	if(cvBns.length==0){%>
						<tr>
							<td>����Ÿ�� �����ϴ�.
							</td>
						</tr>
						<%	}%>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>	
		<%	}%>				
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">�湮���</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
				    	<tr>
				    		<th width="70">�湮����</th>
				    		<td><input type="text" name="vst_dt" value='<%=cvBn.getVst_dt()%>' size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
								<%if(seq.equals("")){%>
								<input type='radio' name="date_type1" value='1' onClick="javascript:date_type_input(-1)">����
								<input type='radio' name="date_type1" value='1' onClick="javascript:date_type_input(0)" checked>����
								<%}%>
							</td>
				    	</tr>	
				    	<tr>
				    		<th>�湮����</th>
				    		<td><%if(seq.equals("")){%>
							<select name="vst_pur">
                                      <option value="">==����==</option>
                                      <option value="1">��ȸ�湮</option>
                                      <option value="2">�ڵ�������</option>
                                      <option value="3">�����</option>
                                      <option value="4">��ü</option>
                                      <option value="5">������Ǻ���</option>
                                      <option value="6">��Ÿ</option>
                                    </select>
									<br>
									<%}%>
									<input type="text" name="vst_title" class='text' size="25" value="<%=cvBn.getVst_title()%>" style='IME-MODE: active'> </td>
				    	</tr>	
						<tr>
							<th>�����</th>
							<td><input type="text" name="sangdamja" class='text' size="25" value="<%=cvBn.getSangdamja()%>" style='IME-MODE: active'></td>
						</tr>											
						<tr>
							<th>��㳻��</th>
							<td><textarea name="vst_cont" cols="25" rows="<%if(seq.equals("")){%>7<%}else{%>15<%}%>"><%=cvBn.getVst_cont()%></textarea></td>
						</tr>											
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>								
			
	</div>
	<div id="cbtn"><a href="javascript:VstReg();"><%if(seq.equals("")){%><img src=/smart/images/btn_reg.gif align=absmiddle border=0><%}else{%><img src=/smart/images/btn_modify.gif align=absmiddle border=0><%}%></a></div>	
	<div id="footer"></div>  
</div>
</form>
<script language="JavaScript">
<!--
	<%if(seq.equals("")){%>
	date_type_input(0);
	<%}%>
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
