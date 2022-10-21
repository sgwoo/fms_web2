<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0" />
<style type="text/css">

/* body 공통 속성 */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '나눔고딕'; }
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0; text-align:center;}

/* 레이아웃 큰박스 속성 */
#wrap {float:left; margin:0 auto; width:100%; background-color:#322719;}
#header {float:left; width:100%; height:43px; margin-bottom:30px;}
#contents {float:left; width:100%; height:100%;}
#footer {float:left; width:100%; height:50px; background:#CCC; margin-top:20px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; text-align:middle; width:100%; height:47px; margin-bottom:10px; background:url(/smart/images/cl_smain_mbg.gif);}
#gnb_menu a{text-decoration:none; color:#fff; line-height:32px; display:block;}
#menu_mn {float:left; height:47px; font-size:0.95em; font-weight:bold; text-align:left;}
#menu_tt {float:left; padding:15px 0 0 5px; height:47px; font-size:0.95em; color:#fff; font-weight:bold;}
#menu_tt em{color:#f84e12}
#menu_mrg {float:right;}

/* 로고 */
#gnb_box {float:left; text-align:middle;  text-shadow:1px 1px 1px #000;  width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}

.List li {padding:0 21px;border-bottom:0px #eaeaea solid; color:#fff; font-weight:bold;}

</style>

<style type="text/css">
/*하이퍼링크 밑줄제거*/
A:link {text-decoration:none}
A:visited {text-decoration:none}
A:hover {text-decoration:none}
</style>


<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/smart/cookies.jsp" %>

<%
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	int    cont_cnt 	= request.getParameter("cont_cnt")==null?0:AddUtil.parseInt(request.getParameter("cont_cnt")); //계약건수
	String st			= request.getParameter("st")==null?"":request.getParameter("st");
	String site_seq 	= request.getParameter("site_seq")==null?"":request.getParameter("site_seq");
	String site_nm 		= request.getParameter("site_nm")==null?"":request.getParameter("site_nm");
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm 		= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	
	//get 방식으로 가기위해
	t_wd = "";
	s_kd = "";
	
	hidden_value = "?s_width="+s_width+"&s_height="+s_height+"&auth_rw="+auth_rw+"&s_kd="+s_kd+"&t_wd="+t_wd+"&t_wd1="+t_wd1+"&t_wd2="+t_wd2+"&s_br="+s_br+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&gubun6="+gubun6+"&gubun7="+gubun7+"&gubun8="+gubun8+"&chk1="+chk1+"&chk2="+chk2+"&chk3="+chk3+"&chk4="+chk4+"&chk5="+chk5+"&chk6="+chk6+"&chk7="+chk7+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&asc="+asc+"&idx="+idx;
	
	hidden_value += "&client_id="+client_id+"&firm_nm="+firm_nm+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+
			"&car_mng_id="+car_mng_id+"&cont_cnt="+cont_cnt+"&site_seq="+site_seq+"&site_nm="+site_nm+
			"&car_no="+car_no+"&car_nm="+car_nm+"";		
			
	//사업장현황
	Vector vt = a_db.getContClientStat(client_id, "");
	int vt_size = vt.size();
%>
<script language='javascript'>
<!--
	function view_info(site_nm, site_seq)
	{
		var fm = document.form1;		
		fm.site_nm.value = site_nm;		
		fm.site_seq.value = site_seq;	
		
		if(fm.st.value == '4'){	
			fm.action = "cont_list.jsp";			//차량리스트
			
			fm.t_wd.value = '';
			fm.s_kd.value = '';
			
		}else if(fm.st.value == '2'){
			if(site_seq == '00'){
				fm.action = "client_view_base.jsp";	 //본사 정보
			}else{
				fm.action = "client_site_view.jsp";	 //사업장 정보
			}			
		}
		
				
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
<%@ include file="/smart/include/search_hidden.jsp" %>
	<input type='hidden' name='client_id' 	value='<%=client_id%>'>
	<input type='hidden' name='firm_nm' 	value='<%=firm_nm%>'>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd' 	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='cont_cnt' 	value='<%=cont_cnt%>'>
	<input type='hidden' name='st' 			value='<%=st%>'>	
	<input type='hidden' name='site_seq'	value=''>
	<input type='hidden' name='site_nm'		value=''>

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login"><span title='<%=firm_nm%>'><%=AddUtil.subData(firm_nm, 10)%></span></div>
			<div id="gnb_home">
				<a href="javascript:view_sitemap()" onMouseOver="window.status=''; return true" title='+메뉴'><img src=/smart/images/button_pmenu.gif align=absmiddle /></a>
				<a href='/smart/main.jsp' title='홈'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
    <div id="contents">
		<%	for (int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				if(st.equals("2") && String.valueOf(ht.get("SEQ")).equals("00")){ // 사업장정보일대 본사는 제외
					//continue;
				}
				%>
		<a href="<%if(st.equals("4")){%>cont_list<%}else{%><%if(String.valueOf(ht.get("SEQ")).equals("00")){%>client_view_base<%}else{%>client_site_view<%}%><%}%>.jsp<%=hidden_value%>&site_nm=<%=ht.get("R_SITE")%>&site_seq=<%=ht.get("SEQ")%>">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/fms_ssub_m1.gif" alt="menu1" /></div>
            <div id="menu_tt"><%=AddUtil.subData(String.valueOf(ht.get("R_SITE")), 9)%> <em><%=ht.get("CONT_Y_CNT")%>대</em></div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>
		</a>
		<%	}%>
		<%	//if(st.equals("2") && vt_size==1){%>
		<!--
		<ul class="List">
			<li>사업장이 없습니다.</li>
		</ul>
		-->
		<%	//}%>
    </div>
    <div id="footer"></div>
</div>
</form>

</body>
</html>
