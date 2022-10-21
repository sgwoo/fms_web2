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

/* body 공통 속성 */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '나눔고딕';}
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0;}

/* 레이아웃 큰박스 속성 */
#wrap {float:left; margin:0 auto; width:100%; background-color:#fff;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%;}
#footer {float:left; width:100%; height:50px; background:#C3C3C3; margin-top:20px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* 로고 */
#gnb_box {float:left; text-align:middle; width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}

/* 검색창 */
#search fieldset {padding:0px 0px; border:0px;}
#search .userform {width:100%; overflow:hidden; position:relative;}
#search .userform .title {float:left; margin-right:10px; height:40px;}
#search .userform .name { margin:0 20px 0 45px;}
#search .userform .userinput {padding-right:50px; height:40px; margin:0 20px 0 50px;}
#search .userform .userinput input.text {border:1px solid #c9c9c9; width:100%; height:23px; font-weight:bold; font-size:0.95em; vertical-align:top;}
#search .userform .submit {float:left; position:absolute; right:0; top:0; padding-right:20px;}

/* UI Object */

.srch{width:100%;padding:5px 0}
.srch legend{overflow:hidden;visibility:hidden;position:absolute;top:0;left:0;width:1px;height:1px;font-size:0;line-height:0}
.srch{color:#c4c4c4;text-align:center}
.srch select,.srch input{margin:-1px 0 1px;font-size:12px;color:#373737;vertical-align:middle}
.srch .keyword{margin-left:1px;padding:2px 3px 5px;border:1px solid #b5b5b5;font-size:12px;line-height:15px}
.srch .white{margin-left:1px;padding:2px 3px 5px;border:0px solid #b5b5b5;font-size:12px;line-height:15px}
/* //UI Object */


/* 리스트 */
.search_list {width:100%; text-align:center; border-bottom:2px solid #b0baec; border-collapse:collapse;}
.search_list caption {display:none;}
.search_list th {padding:7px 0 4px 0; background-color:#e2e7ff; border-top:2px solid #b0baec; border-left:1px solid #b0baec; border-right:1px solid #b0baec; border-bottom:1px solid #b0baec; font-size:14px; font-family:NanumGothic, '나눔고딕'; font-weight:bold; color:#666666;}
.search_list td {padding:6px 0 4px 0; border:1px solid #b0baec; color:#4C4C4C#  font-size:14px; font-family:NanumGothic, '나눔고딕';}

td {padding:6px 0 4px 0; border:0px solid #b0baec; color:#4C4C4C#  font-size:14px; font-family:NanumGothic, '나눔고딕';}

#contentsWrap { padding:0; font-size:22px;} /* padding _ top bottom */
#topListWrap { position: relative; height: 100%; }
.List li {padding:0 21px;border-bottom:1px #eaeaea solid;}
.List li a {width:100%;padding:2px 0 3px;font-size:16px;color:#000;line-height:17px;font-weight:bold;display:block;}
.List li a em {color:#888;font-size:16px;}
.List .list1{float:left;margin-right:10px;}
.List .list2{height:33px;display:block;overflow:hidden;padding:0.8em 0px 0.3em;_float:left;_padding-right:1em;white-space:nowrap;text-overflow:ellipsis;}
</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.*, acar.estimate_mng.*, acar.user_mng.*"%>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<%@ include file="/smart/cookies.jsp" %> 

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	String s_yy 		= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm 		= request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	String s_dd 		= request.getParameter("s_dd")==null?AddUtil.getDate(3):request.getParameter("s_dd");
	String reg_id 		= request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	gubun4 		= request.getParameter("gubun4")==null?"2":request.getParameter("gubun4");
	String s_dt 		= request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt 		= request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	 t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	user_bean = umd.getUsersBean(user_id);
	
	if(reg_id.equals("")){
		if(!user_bean.getLoan_st().equals("")){
			reg_id = user_id;
		}
	}
	
	EstimateBean [] e_r = e_db.getShCarEstimateList(reg_id, s_yy, s_mm, s_dd, gubun4, t_wd);
	int size = e_r.length;
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP"); //영업담당자 리스트
	int user_size = users.size();
%>

<style type=text/css>
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style1 {color: #828282;
         font-size: 11px;}
.style2 {color: #ff00ff;
         font-size: 11px;} 
.style3 {color: #727272}
.style4 {color: #ef620c}
.style5 {color: #334ec5;
        font-weight: bold;} 
-->

</style>


<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		fm.target =  "_self";
		fm.action =  "sh_car_esti_list.jsp";
		fm.submit();
	}

	//디스플레이 타입//기간설정
	function cng_dt(){
		var fm = document.form1;
		if(fm.gubun4.options[fm.gubun4.selectedIndex].value == '3'){ //기간
			esti.style.display 	= '';
		}else{
			esti.style.display 	= 'none';
		}
	}
	
	//선택메일발송
	function select_email(){
		var fm = document.form1;
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}			
		if(cnt == 0){
		 	alert("견적을 선택하세요.");
			return;
		}	
		
		fm.target = "_blank";
		fm.action = "/acar/apply/select_mail_input.jsp";
		fm.submit();	

	}			
//-->
</script>

</head>

<body>
<table width=100% border=0 cellspacing=0 cellpadding=0>
<form name='form1' method='post' action='sh_car_esti_list.jsp'>
	<input type='hidden' name="s_width" 	value="<%=s_width%>">   
	<input type='hidden' name="s_height" 	value="<%=s_height%>">     
	<input type='hidden' name="sh_height" 	value="<%=sh_height%>">   
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' 		value='<%=br_id%>'>
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>    
	<input type='hidden' name='est_id' 		value=''>    
	

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
            <div id="gnb_login">재리스견적리스트</div>
			<div id="gnb_home">
				<a href="esti_main.jsp" onMouseOver="window.status=''; return true" title='이전화면 가기'><img src=/smart/images/button_back.gif align=absmiddle /></a>
				<a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>            
        </div>
    </div>
 	 
    <div id="contents">		
    	<div id="search">
<!--ui object -->
		<fieldset class="srch">
			<legend>검색영역</legend>
			<%if(user_bean.getLoan_st().equals("")){%>
				작성자 : <select name="reg_id">
        			    <option value="">선택</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(reg_id.equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                </select>
			<%}else{%>				
				<input type='hidden' name='reg_id' value='<%=reg_id%>'>
			<%}%>
			&nbsp;견적일자	:<select name="gubun4" onChange='javascript:cng_dt()'>
					<option value="">전체</option>
					<option value="1" <%if(gubun4.equals("1"))%>selected<%%>>당월</option>
					<option value="5" <%if(gubun4.equals("5"))%>selected<%%>>전월</option>
					<option value="2" <%if(gubun4.equals("2"))%>selected<%%>>당일</option>
					<option value="4" <%if(gubun4.equals("4"))%>selected<%%>>전일</option>
					<option value="3" <%if(gubun4.equals("3"))%>selected<%%>>기간</option>
                    </select>
				<div id='esti' style="display:<%if(!gubun4.equals("3")){%>none<%}else{%>''<%}%>">
					<input type="text" name="s_dt" size="11" value="<%=AddUtil.ChangeDate2(s_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
					~ 
					<input type="text" name="e_dt" size="11" value="<%=AddUtil.ChangeDate2(e_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                </div><br>
			
			<input alt=검색 src="/smart/images/btn_srch.gif" type="image"> 
			<br>
			<br>
			<a href="javascript:select_email();" title='선택 메일발송하기'><img src=http://fms1.amazoncar.co.kr/acar/images/center/button_send_smail.gif align=absmiddle border=0></a>
			
		</fieldset> 
<!--//ui object -->
		</div>
		<br>	
        <tbody>	
           <%	for(int i=0; i<size; i++){
					bean = e_r[i];%>
        		<ul class="List">
	            	<li> 
						<span><input type="checkbox" name="ch_l_cd" value="<%=bean.getEst_id()%>">&nbsp;</span>  		                  
		               	<span><a href="sh_car_esti_u.jsp?est_id=<%=bean.getEst_id()%>"><%=bean.getEst_nm()%> <%=bean.getEst_email()%></a></span>						  	 
		               	<span class='list2'>
							<font color="#990000"><%=c_db.getNameByIdCode("0009", "", bean.getA_a())%> <%=bean.getA_b()%>개월</font>
							&nbsp;(<%=bean.getReg_id()%>)
						</span>
	                    <span>
						  	<a href="sh_car_esti_u.jsp?est_id=<%=bean.getEst_id()%>"><%= AddUtil.ChangeDate3(bean.getReg_dt()) %></a>&nbsp;
						</span>						 									
	                    <span>
							대여료: <%=Util.parseDecimal(bean.getFee_s_amt()+bean.getFee_v_amt())%>원
						</span>						 									
               		 </li>
        		</ul>		
          <%	}%> 
		  <%if(size==0){%>
        		<ul class="List">
	               	  <li><span>&nbsp;</span>     
						 <span>데이타가 없습니다.</span>     				 									
               		 </li>
        		</ul>				  
		  <%}%>
    		  <span>&nbsp;</span>      	     
		</tbody>		
	</div>    
</div>
</form>
</table>
</body>
</html>