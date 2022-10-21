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

/* body 공통 속성 */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '나눔고딕';}
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0;}

/* 레이아웃 큰박스 속성 */
#wrap {float:left; margin:0 auto; width:100%; background-color:#dedbcd;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%; height:100%;}
#footer {float:left; width:100%; height:40px; background:#44402d; margin-top:40px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* 로고 */
#gnb_box {float:left; text-align:middle; width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}


/* 둥근테이블 시작 */

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




/* 내용테이블 */
.contents_box {width:100%; table-layout:fixed; font-size:13px;}
.contents_box th {color:#282828; width:90px; height:28px; text-align:left; font-weight:bold; font-size:15px;}
.contents_box td {line-height:16px; color:#7f7f7f; font-weight:bold;}
.contents_box em{color:#fd5f00; font-weight:bold;}



/* 제목테이블 */
#ctitle {float:left; margin:3px 0 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:15px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}


</style>

<script language='javascript'>
<!--
	function view_sitemap()
	{
		var fm = document.form1;	
		fm.action = "sitemap.jsp";		
		fm.submit();
	}					
//-->
</script>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.car_register.*, acar.off_ls_hpg.*, acar.res_search.*"%>
<jsp:useBean id="oh_db" class="acar.off_ls_hpg.OfflshpgDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
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
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	//번호변경이력
	CarHisBean ch_r [] = crd.getCarHisAll(car_mng_id);
	
	//장기대여이력
	Vector vt1 = oh_db.getCarHisList(car_mng_id);
	int vt_size1 = vt1.size();
	
	//단기대여이력
	Vector vt2 = rs_db.getResCarList(car_mng_id);
	int vt_size2 = vt2.size();
%>

<body>

<form name='form1' method='post' action=''>
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
			<div id="gnb_login"><%=car_no%></div>
            <div id="gnb_home">
				<a href="javascript:view_sitemap()" onMouseOver="window.status=''; return true" title='+메뉴'><img src=/smart/images/button_pmenu.gif align=absmiddle /></a>
            	<a href='/smart/main.jsp' title='홈'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
    <div id="contents">
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">번호변경이력</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<%	for(int i=0; i<ch_r.length; i++){
        			       		ch_bean = ch_r[i];%>
						<tr>
				    		<th><%=ch_bean.getCha_car_no()%> | <%=ch_bean.getCha_dt()%> | 
							<% if(ch_bean.getCha_cau().equals("1")){%>
		                    사용본거지 변경 
        		            <%}else if(ch_bean.getCha_cau().equals("2")){%>
		                    용도변경 
        		            <%}else if(ch_bean.getCha_cau().equals("3")){%>
                		    기타 
		                    <%}else if(ch_bean.getCha_cau().equals("4")){%>
        		            없음 
                		    <%}else if(ch_bean.getCha_cau().equals("5")){%>
		                    신규등록 
        		            <%}%>
							</th>
				    	</tr>	
						<%}%>
						<%if(ch_r.length==0){%>
						<tr>
				    		<th>데이타가 없습니다.</th>
				    	</tr>	
						<%}%>
				    </table>

			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>

		</div>						
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">장기대여이력</div>		
    	<%for (int i = 0 ; i < vt_size1 ; i++){
				Hashtable ht = (Hashtable)vt1.elementAt(i);%>
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
				    		<th><%=ht.get("FIRM_NM")%>
				    		<%if(!String.valueOf(ht.get("FIRM_NM")).equals("(주)아마존카")){//장기대여차%><br /></th>
				    	</tr>
				    	<tr>
				    		<td valign=top><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%>
				    		&nbsp;<%if(String.valueOf(ht.get("CLS_ST")).equals("1")){%>
		                      <font color=#fd5f00>[계약만료]</font>
		                      <%}else if(ht.get("CLS_ST").equals("2")){%>
		        			  <font color=#fd5f00>[중도해약]</font>
		                      <%}else if(ht.get("CLS_ST").equals("3")){%>
		        			  <font color=#fd5f00>[영업소변경]</font>
		                      <%}else if(ht.get("CLS_ST").equals("4")){%>
		        			  <font color=#fd5f00>[차종변경]</font>
		                      <%}else if(ht.get("CLS_ST").equals("5")){%>
		        			  <font color=#fd5f00>[계약승계]</font>
		                      <%}else if(ht.get("CLS_ST").equals("6")){%>
		        			  <font color=#fd5f00>[매각]</font>
		                      <%}else if(ht.get("CLS_ST").equals("7")){%>
		        			  <font color=#fd5f00>[출고전해지]</font>
		                      <%}else if(ht.get("CLS_ST").equals("8")){%>
		        			  <font color=#fd5f00>[매입옵션]</font>
		                      <%}else if(ht.get("CLS_ST").equals("9")){%>
		        			  <font color=#fd5f00>[폐차]</font>
		                      <%}else if(ht.get("CLS_ST").equals("10")){%>
		        			  <font color=#fd5f00>[개시전해지]</font>
		                      <%}%>	</td>
		                 </tr>			
							<%}else{%>	
						<tr>
							<td valign=top>
							<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>			
							<%}%></td>
				    	</tr>
				    </table>

			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>

		</div>
		<%}%>
		<%if(vt_size1==0){%>
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">데이타가 없습니다.
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>

		</div>		
		<%}%>
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">단기대여이력</div>		
    	<%for (int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vt2.elementAt(i);%>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
				    		<th><%=ht.get("FIRM_NM")%> <%=ht.get("D_CAR_NO")%></th>
				    	</tr>
				    	<tr>
				    		<td valign=top><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DELI_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RET_DT")))%>
							<font color=#fd5f00>[<%=ht.get("RENT_ST")%>]</font>
							</td>
		                 </tr>								
				    </table>

			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>

		</div>	
		<%}%>	
		<%if(vt_size2==0){%>
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">데이타가 없습니다.
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>

		</div>		
		<%}%>								
	</div>
	<div id="footer"></div>  
</div>
</form>
</body>
</html>
