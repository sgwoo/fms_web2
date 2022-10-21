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
.contents_box th {color:#282828; width:90px; height:28px; text-align:left; font-weight:bold; font-size:14px;}
.contents_box td {line-height:16px; height:20px; color:#7f7f7f; font-weight:bold;}
.contents_box em{color:#fd5f00; font-weight:bold;}



/* 제목테이블 */
#ctitle {float:left; margin:3px 0 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:15px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}



</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.*, acar.off_ls_hpg.*"%>
<jsp:useBean id="oh_db" scope="page" class="acar.off_ls_hpg.OfflshpgDatabase"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vt = oh_db.getAccidCarHisList(car_mng_id);
	int vt_size = vt.size();
%>

<body>

<form name='form1' method='post' action=''>
<%@ include file="/smart/include/search_hidden.jsp" %>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd'	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='from_page'	value='<%=from_page%>'>
	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">
        	
			<div id="gnb_login"><%=car_no%> 사고이력표</div>
            <div id="gnb_home"><a href="rlscar_list.jsp" onMouseOver="window.status=''; return true" title='리스트 가기'><img src=/smart/images/button_list.gif align=absmiddle /></a>
			<a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
        </div>
    </div>
    <div id="contents">
    <%for (int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						String f_item = "";
						String a_item = "";
						
						if(!String.valueOf(ht.get("SERV_ID")).equals("")){
						
							Vector vt2 = oh_db.getServItemCarHisList(car_mng_id, String.valueOf(ht.get("SERV_ID")), String.valueOf(ht.get("ACCID_ID")));
							int vt_size2 = vt2.size();
							
							for (int j = 0 ; j < vt_size2 ; j++){
								Hashtable ht2 = (Hashtable)vt2.elementAt(j);
								
								if(j==0){
								 	f_item 	= String.valueOf(ht2.get("ITEM"));
								}
								
								if(j==vt_size2-1){
			    		        	a_item += String.valueOf(ht2.get("ITEM"));
			        		    }else{
				            		a_item += String.valueOf(ht2.get("ITEM"))+",";
				    	        }
			    	    	}
						}
					%>
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">					
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
				    		<th>연번</th>
				    		<td><font color=#fd5f00><%=vt_size-i%></font></td>							
				    	</tr>
						<tr>
				    		<th>사고구분</th>
				    		<td><%=ht.get("ACCID_ST_NM")%>
								-
								<%if(String.valueOf(ht.get("DAM_TYPE1")).equals("Y")){%> 대인<%}%>
								<%if(String.valueOf(ht.get("DAM_TYPE2")).equals("Y")){%> 대물<%}%>
								<%if(String.valueOf(ht.get("DAM_TYPE3")).equals("Y")){%> 자손<%}%>
								<%if(String.valueOf(ht.get("DAM_TYPE4")).equals("Y")){%> 자차<%}%>
							
							</td>
				    	</tr>
						<tr>
				    		<th>발생일시</th>
				    		<td><%=AddUtil.ChangeDate3(String.valueOf(ht.get("ACCID_DT")))%></td>							
				    	</tr>
						<tr>
				    		<th>계약자</th>
				    		<td><%if(String.valueOf(ht.get("FIRM_NM")).equals("(주)아마존카") && !String.valueOf(ht.get("RENT_S_CD")).equals("")){%>
								[<%=ht.get("RES_ST")%>] <%=ht.get("CUST_NM")%>
								<%}else{%>
								<%=ht.get("FIRM_NM")%>
								<%}%>
							</td>
				    	</tr>
						<%	String accid_cont = "";
							if(!String.valueOf(ht.get("ACCID_CONT")).equals("")) 									accid_cont = String.valueOf(ht.get("ACCID_CONT"));
							if(!String.valueOf(ht.get("ACCID_CONT")).equals(String.valueOf(ht.get("ACCID_CONT2")))) accid_cont = accid_cont+" "+String.valueOf(ht.get("ACCID_CONT2"));
							if(accid_cont.equals(""))																accid_cont = String.valueOf(ht.get("SUB_ETC"));
							%>
						<tr>
				    		<th>사고내용</th>
				    		<td><%=accid_cont%></td>
				    	</tr>
						<tr>
				    		<th>담당자</th>
				    		<td><%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%></td>
				    	</tr>						
						<tr>
				    		<th>수리비용</th>
				    		<td><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%>원</td>
				    	</tr>
						<%if(!String.valueOf(ht.get("SERV_ID")).equals("")){%>
						<tr>
				    		<th>수리품목</th>
				    		<td><%if(!a_item.equals("")){%><%=a_item%><%}else{%><%=ht.get("REP_ITEM")%> <%=ht.get("REP_CONT")%><%}%></td>
				    	</tr>		
						<%}%>				
				    </table>

			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<%}%>
		<%if(vt_size==0){%>
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">		
				데이타가 없습니다.
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
