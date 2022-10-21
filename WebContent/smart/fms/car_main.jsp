<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0" />
<style type="text/css">

/* body ���� �Ӽ� */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '�������'; }
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0; text-align:center;}

/* ���̾ƿ� ū�ڽ� �Ӽ� */
#wrap {float:left; margin:0 auto; width:100%; background-color:#322719;}
#header {float:left; width:100%; height:43px; margin-bottom:30px;}
#contents {float:left; width:100%; height:100%px;}
#footer {float:left; width:100%; height:50px; background:#CCC; margin-top:20px;}

/* �޴������ܵ� */
#gnb_menu {float:left; text-align:middle; width:100%; height:47px; margin-bottom:10px; background:url(/smart/images/cl_smain_mbg.gif);}
#gnb_menu a{text-decoration:none; color:#fff; line-height:32px; display:block;}
#menu_mn {float:left; height:42px; font-size:0.95em; font-weight:bold; text-align:left;}
#menu_tt {float:left; padding:4px 0 0 5px; line-height:42px; font-size:0.95em; color:#fff; font-weight:bold; }
#menu_mrg {float:right;}

/* �ΰ� */
#gnb_box {float:left; text-align:middle;  text-shadow:1px 1px 1px #000;  width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}
</style>

<style type="text/css">
/*�����۸�ũ ��������*/
A:link {text-decoration:none}
A:visited {text-decoration:none}
A:hover {text-decoration:none}
</style>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/smart/cookies.jsp" %>

<%
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	int    cont_cnt 	= request.getParameter("cont_cnt")==null?0:AddUtil.parseInt(request.getParameter("cont_cnt")); //���Ǽ�
	String st			= request.getParameter("st")==null?"":request.getParameter("st");
	
	String site_seq 	= request.getParameter("site_seq")==null?"":request.getParameter("site_seq");
	String site_nm 		= request.getParameter("site_nm")==null?"":request.getParameter("site_nm");
	
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm 		= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	
	//get ������� ��������
	t_wd = "";
	s_kd = "";
	
	hidden_value = "?s_width="+s_width+"&s_height="+s_height+"&auth_rw="+auth_rw+"&s_kd="+s_kd+"&t_wd="+t_wd+"&t_wd1="+t_wd1+"&t_wd2="+t_wd2+"&s_br="+s_br+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&gubun6="+gubun6+"&gubun7="+gubun7+"&gubun8="+gubun8+"&chk1="+chk1+"&chk2="+chk2+"&chk3="+chk3+"&chk4="+chk4+"&chk5="+chk5+"&chk6="+chk6+"&chk7="+chk7+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&asc="+asc+"&idx="+idx;
	
	hidden_value += "&client_id="+client_id+"&firm_nm="+firm_nm+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+
			"&car_mng_id="+car_mng_id+"&cont_cnt="+cont_cnt+"&site_seq="+site_seq+"&site_nm="+site_nm+
			"&car_no="+car_no+"&car_nm="+car_nm+"";		
			
%>
<script language='javascript'>
<!--
	function view_info(st)
	{
		var fm = document.form1;
		
		if(st == '1'){
			fm.action = "car_view_base.jsp";		
		}else if(st == '2'){
			fm.action = "car_view_pur.jsp";		
		}else if(st == '3'){
			fm.action = "car_view_opt.jsp";		
		}else if(st == '4'){
			fm.action = "car_view_his.jsp";		
		}else if(st == '5'){
			fm.action = "car_view_accid.jsp";		
		}else if(st == '6'){
			fm.action = "car_view_ins.jsp";		
		}else if(st == '7'){
			fm.action = "car_view_serv.jsp";		
		}else if(st == '8'){
			fm.action = "car_view_maint.jsp";		
		}
		
		fm.submit();
	}
	
	function view_client()
	{
		var fm = document.form1;		
		fm.action = "fms_menu.jsp";		
		fm.submit();
	}		
	
	function view_sitemap()
	{
		var fm = document.form1;	
		fm.action = "sitemap.jsp";		
		fm.submit();
	}					
//-->
</script>
</head>
<body>
<form name="form1" method="post" action="">
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='client_id' 	value='<%=client_id%>'>
	<input type='hidden' name='firm_nm' 	value='<%=firm_nm%>'>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd'	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='cont_cnt' 	value='<%=cont_cnt%>'>
	<input type='hidden' name='st' 			value='<%=st%>'>	
	<input type='hidden' name='site_seq'	value='<%=site_seq%>'>
	<input type='hidden' name='site_nm'		value='<%=site_nm%>'>	
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='car_nm' 		value='<%=car_nm%>'>		

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">
				<%if(car_no.equals("�̵��")){%><%=rent_l_cd%> <%=car_nm%><%}else{%><%=car_no%><%}%>
			</div>
			<div id="gnb_home">
				<a href="javascript:view_sitemap()" onMouseOver="window.status=''; return true" title='+�޴�'><img src=/smart/images/button_pmenu.gif align=absmiddle /></a>
				<!--<a href=/smart/fms/fms_list.jsp onMouseOver="window.status=''; return true" title='�˻�'><img src=/smart/images/button_search.gif align=absmiddle /></a>-->
				<!--<a href="javascript:view_client()" onMouseOver="window.status=''; return true" title='��'><img src=/smart/images/btn_cus.gif align=absmiddle /></a>-->
				<a href='/smart/main.jsp' title='Ȩ'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
    <div id="contents">
		<a href="car_view_base.jsp<%=hidden_value%>&st=1">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/fms_ssub_m8.gif" alt="menu1" /></div>
            <div id="menu_tt">�⺻����</div>
            <div id="menu_mrg"><img src="/acar./images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>
		</a>
		<a href="car_view_pur.jsp<%=hidden_value%>&st=1">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/fms_ssub_m10.gif" alt="menu2" /></div>
            <div id="menu_tt">��������</div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>
		</a>
		<a href="car_view_opt.jsp<%=hidden_value%>&st=1">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/sl_m5.gif" alt="menu2" /></div>
            <div id="menu_tt">�������</div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>
		</a>
		<%if(!car_mng_id.equals("")){%>
		<a href="car_view_his.jsp<%=hidden_value%>&st=1">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/sl_m2.gif" alt="menu2" /></div>
            <div id="menu_tt">�̷�����</div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>
		</a>
		<%}%>
		
		<a href="car_view_accid.jsp<%=hidden_value%>&st=1">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/sl_m3.gif" alt="menu2" /></div>
            <div id="menu_tt">�������</div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>
		</a>
		<a href="car_view_serv.jsp<%=hidden_value%>&st=1">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/sl_m4.gif" alt="menu2" /></div>
            <div id="menu_tt">��������</div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>
		</a>
		<a href="car_view_maint.jsp<%=hidden_value%>&st=1">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/fms_ssub_m11.gif" alt="menu2" /></div>
            <div id="menu_tt">�˻�����</div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>
		</a>
		<a href="car_view_ins.jsp<%=hidden_value%>&st=1">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/fms_ssub_m9.gif" alt="menu2" /></div>
            <div id="menu_tt">���պ���</div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>
		</a>
    </div>
    <div id="footer"></div>
</div>
</form>

</body>
</html>
