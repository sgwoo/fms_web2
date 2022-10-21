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
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%; height:100%;}
#footer {float:left; width:100%; height:50px; background:#CCC; margin-top:20px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; text-align:middle; width:100%; height:47px; margin-bottom:10px; background:url(/smart/images/cl_smain_mbg.gif);}
#gnb_menu a{text-decoration:none; color:#fff; line-height:32px; display:block;}
#menu_mn {float:left; height:47px; font-size:0.95em; font-weight:bold; text-align:left;}
#menu_mnt {float:left;  padding:15px 0 0 4px; color:#fff; font-weight:bold;}
#menu_tt {float:right; font-weight:bold; color:#fff; padding:15px 55px 0 0; position:absolute; right:0;}
#menu_tt em{color:#4ff5f3}
#menu_mrg {float:right;}


#gnb_sum {float:left; width:100%; height:47px; margin-bottom:10px; background:url(/smart/images/fms_smain_bg.gif);}
#gnb_tt {float:left; height:47px; font-size:0.95em; font-weight:bold; text-align:left;}
#gnb_t {float:left;  padding:15px 0 0 4px; color:#fff; font-weight:bold;}
#gnb_pr {float:right; font-weight:bold; color:#fff; padding:15px 55px 0 0; position:absolute; right:0; font-size:17px;}
#gnb_pr em{color:#fde83a}
#gnb_mrg {float:right;}

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
<%@ page import="java.util.*, acar.util.*, acar.settle_acc.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
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
	
	String from_page 		= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	gubun3 = "1"; //수금
	gubun4 = "";  //전체
	
	
	Vector vt = new Vector();
	int vt_size = 0;
	
	int  pre_size 	= 0;
	long pre_amt 	= 0;
	int  fine_size 	= 0;
	long fine_amt 	= 0;
	int  serv_size 	= 0;
	long serv_amt 	= 0;
	int  dly_size 	= 0;
	long dly_amt 	= 0;
	int  fee_size 	= 0;
	long fee_amt 	= 0;
	int  rent_size 	= 0;
	long rent_amt 	= 0;
	int  cls_size 	= 0;
	long cls_amt 	= 0;
	int  accid_size = 0;
	long accid_amt 	= 0;
	
	//선수금
	vt = s_db.getGrtList2(gubun3, gubun4, "1", rent_l_cd, "");//(String gubun3, String gubun4, String s_kd, String t_wd)
	vt_size = vt.size();
	pre_size=vt_size;
	for (int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		pre_amt += AddUtil.parseLong(String.valueOf(ht.get("EXT_AMT")));
	}
	
	//과태료
	vt = s_db.getFineList(gubun3, gubun4, "1", rent_l_cd, "");//(String gubun3, String gubun4, String s_kd, String t_wd)
	vt_size = vt.size();
	fine_size=vt_size;
	for (int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		fine_amt += AddUtil.parseLong(String.valueOf(ht.get("PAID_AMT")));
	}
	
	//면책금
	vt = s_db.getInsurMList(gubun3, gubun4, "1", rent_l_cd, "");//(String gubun3, String gubun4, String s_kd, String t_wd)
	vt_size = vt.size();
	serv_size=vt_size;
	for (int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		serv_amt += AddUtil.parseLong(String.valueOf(ht.get("CUST_AMT")));
	}
	
	//연체이자
	vt = s_db.getFeeDlyScd(gubun3, gubun4, "1", rent_l_cd);//(String gubun3, String gubun4, String s_kd, String t_wd)
	vt_size = vt.size();
	dly_size=vt_size;
	for (int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		dly_amt += AddUtil.parseLong(String.valueOf(ht.get("PAY_AMT")));
	}
	
	//대여료
	vt = s_db.getFeeList4(gubun3, gubun4, "1", rent_l_cd, "");//(String gubun3, String gubun4, String s_kd, String t_wd)
	vt_size = vt.size();
	fee_size=vt_size;
	for (int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		fee_amt += AddUtil.parseLong(String.valueOf(ht.get("RC_AMT")));
	}
	
	//단기대여
	vt = s_db.getScdRentMngList_New(gubun3, gubun4, "2", car_mng_id, "");//(String gubun3, String gubun4, String s_kd, String t_wd)
	vt_size = vt.size();
	rent_size=vt_size;
	for (int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		rent_amt += AddUtil.parseLong(String.valueOf(ht.get("PAY_AMT")));
	}
	
	//해지정산금
	vt = s_db.getClsFeeScdList(gubun3, gubun4, "1", rent_l_cd, "");//(String gubun3, String gubun4, String s_kd, String t_wd)
	vt_size = vt.size();
	cls_size=vt_size;
	for (int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		cls_amt += AddUtil.parseLong(String.valueOf(ht.get("EXT_PAY_AMT")));
	}
	
	//휴/대차료
	vt = s_db.getInsurHList(gubun3, gubun4, "1", rent_l_cd, "");//(String gubun3, String gubun4, String s_kd, String t_wd)
	vt_size = vt.size();
	accid_size=vt_size;
	for (int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		accid_amt += AddUtil.parseLong(String.valueOf(ht.get("PAY_AMT")));
	}
	
	long settle_total_amt = pre_amt+fine_amt+serv_amt+dly_amt+fee_amt+rent_amt+cls_amt+accid_amt;
	
	//get 방식으로 가기위해
	t_wd = "";
	s_kd = "";
	
	hidden_value = "?s_width="+s_width+"&s_height="+s_height+"&auth_rw="+auth_rw+"&s_kd="+s_kd+"&t_wd="+t_wd+"&t_wd1="+t_wd1+"&t_wd2="+t_wd2+"&s_br="+s_br+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&gubun6="+gubun6+"&gubun7="+gubun7+"&gubun8="+gubun8+"&chk1="+chk1+"&chk2="+chk2+"&chk3="+chk3+"&chk4="+chk4+"&chk5="+chk5+"&chk6="+chk6+"&chk7="+chk7+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&asc="+asc+"&idx="+idx;
	
	hidden_value += "&client_id="+client_id+"&firm_nm="+firm_nm+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+
			"&car_mng_id="+car_mng_id+"&cont_cnt="+cont_cnt+"&site_seq="+site_seq+"&site_nm="+site_nm+
			"&car_no="+car_no+"&car_nm="+car_nm+"";	
	
	
%>
<script language='javascript'>
<!--
	function view_info(s_item)
	{
		var fm = document.form1;		

		if(s_item == '선수금'){
			fm.action = "cont_view_incom_pre.jsp";		
		}else if(s_item == '과태료'){
			fm.action = "cont_view_incom_fine.jsp";		
		}else if(s_item == '면책금'){
			fm.action = "cont_view_incom_serv.jsp";		
		}else if(s_item == '연체이자'){
			fm.action = "cont_view_incom_dly.jsp";		
		}else if(s_item == '대여료'){
			fm.action = "cont_view_incom_fee.jsp";		
		}else if(s_item == '단기대여료'){
			fm.action = "cont_view_incom_rent.jsp";
		}else if(s_item == '해지정산금'){
			fm.action = "cont_view_incom_cls.jsp";		
		}else if(s_item == '휴/대차료'){
			fm.action = "cont_view_incom_accid.jsp";		
		}

		fm.submit();
	}
	
	function view_before()
	{
		var fm = document.form1;		
		fm.action = "cont_main.jsp";		
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
	<input type='hidden' name='site_seq'	value='<%=site_seq%>'>
	<input type='hidden' name='site_nm'		value='<%=site_nm%>'>	
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='car_nm' 		value='<%=car_nm%>'>		
	<input type='hidden' name='from_page' 	value='<%=from_page%>'>			
	<input type='hidden' name='s_item'		value=''>

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">
				<%if(from_page.equals("fms_menu.jsp")){%>
				<%=AddUtil.subData(firm_nm, 6)%>
				<%}else{%>
				<%=car_no%>
				<%}%>
			</div>
			<div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='이전화면 가기'><img src=/smart/images/button_back.gif align=absmiddle /></a>
				<a href="javascript:view_sitemap()" onMouseOver="window.status=''; return true" title='+메뉴'><img src=/smart/images/button_pmenu.gif align=absmiddle /></a>
				<a href='/smart/main.jsp' title='홈'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
    <div id="contents">
    	<div id="gnb_sum">
    		<div id="gnb_tt"><img src="/smart/images/fms_smain_mrl.gif" alt="menu1" /></div>
        	<div id="gnb_t">합계</div>
        	<div id="gnb_pr"><em><%=AddUtil.parseDecimal(settle_total_amt)%> 원</em></div>
        	 <div id="gnb_mrg"><img src="/smart/images/fms_smain_mrg.gif" alt="mrg" /></a></div>
        </div>
		<a href="cont_view_incom_pre.jsp<%=hidden_value%>&s_item=선수금">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></div>
            <div id="menu_mnt">선수금</div>
            <div id="menu_tt"><em><font color='#f18d00'><%=pre_size%>건</font> <%=AddUtil.parseDecimal(pre_amt)%> 원</em></div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>
		</a>
		<a href="cont_view_incom_fine.jsp<%=hidden_value%>&s_item=과태료">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></div>
            <div id="menu_mnt">과태료</div>
            <div id="menu_tt"><em><font color='#f18d00'><%=fine_size%>건</font> <%=AddUtil.parseDecimal(fine_amt)%> 원</em></div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>
		</a>
		<a href="cont_view_incom_serv.jsp<%=hidden_value%>&s_item=면책금">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></div>
            <div id="menu_mnt">면책금</div>
            <div id="menu_tt"><em><font color='#f18d00'><%=serv_size%>건</font> <%=AddUtil.parseDecimal(serv_amt)%> 원</em></div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>
		</a>
		<a href="cont_view_incom_dly.jsp<%=hidden_value%>&s_item=연체이자">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></div>
            <div id="menu_mnt">연체이자</div>
            <div id="menu_tt"><em><font color='#f18d00'><%=dly_size%>건</font> <%=AddUtil.parseDecimal(dly_amt)%> 원</em></div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>		
		</a>
		<a href="cont_view_incom_fee.jsp<%=hidden_value%>&s_item=대여료">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></div>
            <div id="menu_mnt">대여료</div>
            <div id="menu_tt"><em><font color='#f18d00'><%=fee_size%>건</font> <%=AddUtil.parseDecimal(fee_amt)%> 원</em></div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>
		</a>
		<a href="cont_view_incom_rent.jsp<%=hidden_value%>&s_item=단기대여료">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></div>
            <div id="menu_mnt">단기대여료</div>
            <div id="menu_tt"><em><font color='#f18d00'><%=rent_size%>건</font> <%=AddUtil.parseDecimal(rent_amt)%> 원</em></div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>		
		</a>
		<a href="cont_view_incom_cls.jsp<%=hidden_value%>&s_item=해지정산금">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></div>
            <div id="menu_mnt">해지정산금</div>
            <div id="menu_tt"><em><font color='#f18d00'><%=cls_size%>건</font> <%=AddUtil.parseDecimal(cls_amt)%> 원</em></div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>
		</a>
		<a href="cont_view_incom_accid.jsp<%=hidden_value%>&s_item=휴/대차료">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></div>
            <div id="menu_mnt">휴/대차료</div>
            <div id="menu_tt"><em><font color='#f18d00'><%=accid_size%>건</font> <%=AddUtil.parseDecimal(accid_amt)%> 원</em></div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>		
		</a>
    </div>
    <div id="footer"></div>
</div>
</form>

</body>
</html>
