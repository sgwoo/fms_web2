<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS_Auction</title>
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
#wrap {float:left; margin:0 auto; width:100%; background-color:#322719;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%;}
#footer {float:left; width:100%; height:50px; background:#C3C3C3; margin-top:20px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu a{text-decoration:none; color:#fff;}
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
#search .userform .name {float:left; position:absolute; width:100px; margin:5px 20px 0 20px; color:#ffe4a9;}
#search .userform .userinput {padding-right:60px; height:50px; margin:0 20px 0 85px;}
#search .userform .userinput input.text {border:1px solid #c9c9c9; width:100%; height:23px; font-weight:bold; font-size:0.95em; vertical-align:top;}
#search .userform .submit {float:left; position:absolute; right:0; top:0; padding-right:25px;}


/* UI Object */

.srch{width:100%;padding:5px 0}
.srch legend{overflow:hidden;visibility:hidden;position:absolute;top:0;left:0;width:1px;height:1px;font-size:0;line-height:0}
.srch{color:#c4c4c4;text-align:center}
.srch select,.srch input{margin:-1px 0 1px;font-size:12px;color:#373737;vertical-align:middle}
.srch .keyword{margin-left:1px;padding:2px 3px 5px;border:1px solid #b5b5b5;font-size:12px;line-height:15px}
/* //UI Object */


#dj_list table{margin:auto;width:90%; text-align:center; border-bottom:2px solid #c18d44; border-top:1px solid #c18d44; font:11px Tahoma;}
#dj_list table th{padding:7px 0 4px 0;  border-top:1px solid #c18d44; border-left:1px solid #c18d44; border-right:1px solid #c18d44; font:13px NanumGothic; font-weight:bold; color:#e4ddd4; height:30px;}
#dj_list table td{padding:6px 0 4px 0; border-top:1px solid #c18d44;  font:13px NanumGothic; color:#e4ddd4; font-weight:bold; height:30px ; background-color:#322719;}
#dj_list table a{color:#e4ddd4; padding:8px 8px;}
#dj_list table th.n{border-right:0px;}

li.ment{font-size:0.8em; color:#545454;}
</style>


<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.asset.*"%>
<%@ include file="/smart/cookies.jsp" %>

<%
	
	String s_yy = request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
		
	AssetDatabase ad_db = AssetDatabase.getInstance();
	
	s_yy = AddUtil.replace(s_yy,"-","");
	s_mm = AddUtil.replace(s_mm,"-","");
	
	Vector buss1 = ad_db.getAssetIncomList(s_yy, s_mm);
	int bus_size1 = buss1.size();

	
	int tot_cnt[] 	= new int[6];
	int c_cnt[] 	= new int[6];
	
	int cnt10[] 	= new int[6];
	int cnt20[] 	= new int[6];
	int cnt30[] 	= new int[6];
	int cnt40[] 	= new int[6];
	int cnt50[] 	= new int[6];	
	
	int cnt01[] 	= new int[6];
	int cnt02[] 	= new int[6];
	int cnt03[] 	= new int[6];
	int cnt04[] 	= new int[6];
	int cnt05[] 	= new int[6];
	
	long amt10[] 	= new long[6];
	long amt20[] 	= new long[6];
	long amt30[] 	= new long[6];
	long amt40[] 	= new long[6];	
	long amt50[] 	= new long[6];	
	
	long amt01[] 	= new long[6];
	long amt02[] 	= new long[6];
	long amt03[] 	= new long[6];
	long amt04[] 	= new long[6];
	long amt05[] 	= new long[6];

	int cnt31[] 	= new int[6];
	int cnt32[] 	= new int[6];
	int cnt33[] 	= new int[6];
	int cnt34[] 	= new int[6];
	int cnt35[] 	= new int[6];
	
	int car_type_cnt = 0;
	int car_type_size1 = 0;
	int car_type_size2 = 0;
	int car_type_size3 = 0;
	int car_type_size4 = 0;
	int car_type_size5 = 0;

	for(int i = 0 ; i < bus_size1 ; i++){
		Hashtable ht = (Hashtable)buss1.elementAt(i);
		if(String.valueOf(ht.get("GUBUN")).equals("1")) car_type_size1++;
		if(String.valueOf(ht.get("GUBUN")).equals("2")) car_type_size2++;	
		if(String.valueOf(ht.get("GUBUN")).equals("3")) car_type_size3++;
		if(String.valueOf(ht.get("GUBUN")).equals("4")) car_type_size4++;		
		if(String.valueOf(ht.get("GUBUN")).equals("5")) car_type_size5++;		
	}
	
	float f_cnt[]	= new float[6];
	float f_s_cnt[]	= new float[6];
	float f_t_cnt[]	= new float[6];
		
%>

<!--<link rel=stylesheet type="text/css" href="/include/table_t.css"> -->
<script language='JavaScript' src='/smart/include/common.js'></script>

<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		fm.action = 'stat_asset_list.jsp';
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}

			
//-->
</script>

</head>

<body method='post' action='stat_asset_list.jsp'>
<form  name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='bus_size1' value='<%=bus_size1%>'>
 
 <div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
            <div id="gnb_login">경매현황</span></div>
            <div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='이전화면 가기'><img src=/smart/images/button_back.gif align=absmiddle /></a>				
				<a href='/smart/main.jsp' title='홈'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
      <div id="contents">
    	<div id="search">
			<!--ui object -->
			<fieldset class="srch">
				<legend>검색영역</legend>
				<select name="s_yy" >
	          		<% for(int i=2014; i<=AddUtil.getDate2(1); i++){%>
	          		<option value="<%=i%>" <%if(i == AddUtil.parseInt(s_yy)){%> selected <%}%>><%=i%>년도</option>
	          		<%}%>
	        	</select>
				<select name="s_mm">
	          		<option value="" <%if(s_mm.equals("")){%> selected <%}%>>전체</option>         
	          		<% for(int i=1; i<=12; i++){%>        
	          		<option value="<%=AddUtil.addZero2(i)%>" <%if(i == AddUtil.parseInt(s_mm)){%> selected <%}%>><%=AddUtil.addZero2(i)%>월</option>
	          		<%}%>
	        	</select> 			
			
				<input alt=검색 src="/smart/images/btn_srch.gif" type="image"> 
			</fieldset> 
			<!--//ui object -->
		</div>
		<br>
		
		<div id="dj_list">	
		
  			<table border="0" cellspacing="0" cellpadding="0" width=100%>
    			<tr>
						<th  rowspan=2 colspan="2" width="28%"><font color="#c28835">구분</font></th>
						<th  rowspan=2 width="12%"><font color="#f09310">대수</font></th>
						<th  rowspan=2 width="20%"><font color="#f09310">매각수입</font></th>
						<th  colspan=2 width="33%"><font color="#f09310">매각손익</font></th>					
				</tr>
				<tr>
						<th  width="17%"><font color="#f09310">손익계</font></th>
						<th  width="16%"><font color="#f09310">대당평균</font></th>
				</tr>
					 			

          <%	car_type_cnt = 0;
          		for (int i = 0 ; i < bus_size1 ; i++){
					Hashtable ht = (Hashtable)buss1.elementAt(i);
					if(String.valueOf(ht.get("GUBUN")).equals("1")){
										
						String d_nm1 = "";
												
						if(String.valueOf(ht.get("ACTN_ID")).equals("000502")){				d_nm1 = "시화";	
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("013011")){		d_nm1 = "분당";
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("061796")){		d_nm1 = "양산";
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("003226")){		d_nm1 = "매각서울오토";		
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("011723")){		d_nm1 = "매각서울자동차경매";		
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("013222")){		d_nm1 = "매각동화엠파크";
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("020385")){		d_nm1 = "AJ";
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("022846")){		d_nm1 = "롯데"; //매각롯데렌탈
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("048691")){		d_nm1 = "Kcar "; //Kcar 
						
						}
											
						cnt10[0] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT")));  											
					
						amt10[0] 	= AddUtil.parseLong(String.valueOf(ht.get("AMT")));  
						amt20[0] 	= AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));  									
									
					
			%>	
				
          <tr>
            <%if(car_type_cnt==0){%>
             <th align="center"  rowspan='<%=car_type_size1 +1 %>'>리스</th>
		    <%}%>
            <th align="center"  height="20">&nbsp;&nbsp;<%=d_nm1%></th>    
            <th align="right" height="20" width="60"><%=ht.get("CNT")%></th>
            <th align="right" height="20" width="90"><%=Util.parseDecimal(amt20[0])%></th>
            <th align="right" height="20" width="90"><%=Util.parseDecimal(amt10[0])%></th>
            <th align="right" height="20" width="80"><% if ( cnt10[0] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(amt10[0]/cnt10[0])%><% } %></th>              
                  
          </tr>
           <%	car_type_cnt++;               
					cnt01[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT"))); 				
				
					amt01[0] 	+= AddUtil.parseLong(String.valueOf(ht.get("AMT")));  
					amt02[0] 	+= AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));  			
					
			} } %>
			         
          <tr> 
            <th class="title" align="center"  height="20">소계</th>   
            <th class="title"  style="text-align:right" height="20" width="60"><%=cnt01[0]%></th>
            <th class="title"  style="text-align:right" height="20" width="90"><%=Util.parseDecimal(amt02[0])%></th>
            <th class="title"  style="text-align:right" height="20" width="90"><%=Util.parseDecimal(amt01[0])%></th>
            <th class="title"  style="text-align:right" height="20" width="80"><% if ( cnt01[0] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(amt01[0]/cnt01[0])%><% } %></th>                    
          </tr>
          
          <%	car_type_cnt = 0;
          		for (int i = 0 ; i < bus_size1 ; i++){
					Hashtable ht = (Hashtable)buss1.elementAt(i);
					if(String.valueOf(ht.get("GUBUN")).equals("5")){
										
						String d_nm1 = "";
						
						if(String.valueOf(ht.get("ACTN_ID")).equals("000502")){				d_nm1 = "시화";	
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("013011")){		d_nm1 = "분당";			
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("061796")){		d_nm1 = "양산";
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("003226")){		d_nm1 = "매각서울오토";	
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("011723")){		d_nm1 = "매각서울자동차경매";	
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("013222")){		d_nm1 = "매각동화엠파크";
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("020385")){		d_nm1 = "AJ";
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("022846")){		d_nm1 = "롯데"; //매각롯데렌탈
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("048691")){		d_nm1 = "Kcar "; //Kcar 
				
						}
						
					cnt10[4] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT")));
					
				
					amt10[4] 	= AddUtil.parseLong(String.valueOf(ht.get("AMT")));  //2010
					amt20[4] 	= AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));  //2011
		 %>	
				
          <tr>           
            <%if(car_type_cnt==0){%>
             <th align="center" width='60' rowspan='<%=car_type_size5 + 1%>'>렌트<br>(LPG)</th>
		    <%}%>
            <th align="center" width="110" height="20">&nbsp;&nbsp;<%=d_nm1%></th>        
            <th align="right" height="20" width="60"><%=ht.get("CNT")%></td>
            <th align="right" height="20" width="90"><%=Util.parseDecimal(amt20[4])%></th>
            <th align="right" height="20" width="90"><%=Util.parseDecimal(amt10[4])%></th>
            <th align="right" height="20" width="80"><% if ( cnt10[4] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(amt10[4]/cnt10[4])%><% } %></th>  
          </tr>             
           <%		
        		   	car_type_cnt++;
					cnt01[4] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT")));			
					
					amt01[4] 	+= AddUtil.parseLong(String.valueOf(ht.get("AMT")));  //2010
					amt02[4] 	+= AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));  //2011
				
			} } %>         
         
          <tr> 
            <th class="title" align="center"    height="20">소계</th>      
            <th class="title"  style="text-align:right" height="20" width="60"><%=cnt01[4]%></th>
            <th class="title"  style="text-align:right" height="20" width="90"><%=Util.parseDecimal(amt02[4])%></th>
            <th class="title"  style="text-align:right" height="20" width="90"><%=Util.parseDecimal(amt01[4])%></th>
            <th class="title"  style="text-align:right" height="20" width="80"><% if ( cnt01[4] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(amt01[4]/cnt01[4])%><% } %></th>
                 
          </tr>               
               <!--경매렌트 비lpg--> 
               <%	car_type_cnt = 0;
          		for (int i = 0 ; i < bus_size1 ; i++){
					Hashtable ht = (Hashtable)buss1.elementAt(i);
					if(String.valueOf(ht.get("GUBUN")).equals("2")){
										
						String d_nm1 = "";
						
						if(String.valueOf(ht.get("ACTN_ID")).equals("000502")){				d_nm1 = "시화";	
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("013011")){		d_nm1 = "분당";	
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("061796")){		d_nm1 = "양산";
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("003226")){		d_nm1 = "매각서울오토";	
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("011723")){		d_nm1 = "매각서울자동차경매";	
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("013222")){		d_nm1 = "매각동화엠파크";
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("020385")){		d_nm1 = "AJ";
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("022846")){		d_nm1 = "롯데"; //매각롯데렌탈
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("048691")){		d_nm1 = "Kcar "; //Kcar 
					
						}
						
					cnt10[1] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT")));
					
					amt10[1] 	= AddUtil.parseLong(String.valueOf(ht.get("AMT")));  //2010
					amt20[1] 	= AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));  //2011						
		 %>	
				
          <tr>           
            <%if(car_type_cnt==0){%>
             <th align="center" width='60' rowspan='<%=car_type_size2 +1 %>'>렌트<br>(비LPG)</th>
		    <%}%>
            <th align="center" width="110" height="20">&nbsp;&nbsp;<%=d_nm1%></th>    
            <th align="right" height="20" width="60"><%=ht.get("CNT")%></th>
            <th align="right" height="20" width="90"><%=Util.parseDecimal(amt20[1])%></th>
            <th align="right" height="20" width="90"><%=Util.parseDecimal(amt10[1])%></th>
            <th align="right" height="20" width="80"><% if ( cnt10[1] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(amt10[1]/cnt10[1])%><% } %></th>        		   
               
          </tr>        
         
          <%	
          		car_type_cnt++;          				
					cnt01[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT")));
									
					amt01[1] 	+= AddUtil.parseLong(String.valueOf(ht.get("AMT")));  
					amt02[1] 	+= AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));  
									
			} } %>
         
          <tr> 
            <th class="title" align="center"   height="20">소계</th>           
            <th class="title"  style="text-align:right" height="20" width="60"><%=cnt01[1]%></th>
            <th class="title"  style="text-align:right" height="20" width="90"><%=Util.parseDecimal(amt02[1])%></th>
            <th class="title"  style="text-align:right" height="20" width="90"><%=Util.parseDecimal(amt01[1])%></th>
            <th class="title"  style="text-align:right" height="20" width="80"><% if ( cnt01[1] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(amt01[1]/cnt01[1])%><% } %></th>
          </tr>               
                              
                 
             <%	car_type_cnt = 0;
          		for (int i = 0 ; i < bus_size1 ; i++){
					Hashtable ht = (Hashtable)buss1.elementAt(i);
					if(String.valueOf(ht.get("GUBUN")).equals("3")){
										
						String d_nm1 = "";						
				
						if(String.valueOf(ht.get("ACTN_ID")).equals("000000")){		d_nm1 = "매입옵션";						
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("111111")){		d_nm1 = "수의/폐차";						
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("999999")){		d_nm1 = "폐차";	
						}
						
					cnt10[2] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT")));
							
					amt10[2] 	= AddUtil.parseLong(String.valueOf(ht.get("AMT")));  //2012
					amt20[2] 	= AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));  //2013
		 %>	
				
          <tr>           
            <%if(car_type_cnt==0){%>
             <th align="center" width='60' rowspan='<%=car_type_size3 + 1%>'>리스</th>
		    <%}%>
            <th align="center" width="110" height="20">&nbsp;&nbsp;<%=d_nm1%></th>     
            <th align="right" height="20" width="60"><%=ht.get("CNT")%></th>
            <th align="right" height="20" width="90"><%=Util.parseDecimal(amt20[2])%></th>
            <th align="right" height="20" width="90"><%=Util.parseDecimal(amt10[2])%></th>
            <th align="right" height="20" width="80"><% if ( cnt10[2] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(amt10[2]/cnt10[2])%><% } %></th>     
          </tr>
        
          <%		
          		car_type_cnt++;
					cnt01[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT")));
									
					amt01[2] 	+= AddUtil.parseLong(String.valueOf(ht.get("AMT")));  //
					amt02[2] 	+= AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));  //	
					
			} } %>
			        
         
          <tr> 
            <th class="title" align="center"   height="20">소계</th>  
            <th class="title"  style="text-align:right" height="20" width="60"><%=cnt01[2]%></th>
            <th class="title"  style="text-align:right" height="20" width="90"><%=Util.parseDecimal(amt02[2])%></th>
            <th class="title"  style="text-align:right" height="20" width="90"><%=Util.parseDecimal(amt01[2])%></th>
            <th class="title"  style="text-align:right" height="20" width="80"><% if ( cnt01[2] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(amt01[2]/cnt01[2])%><% } %></th>         
          </tr>               
          
            <%	car_type_cnt = 0;
          		for (int i = 0 ; i < bus_size1 ; i++){
					Hashtable ht = (Hashtable)buss1.elementAt(i);
					if(String.valueOf(ht.get("GUBUN")).equals("4")){
										
						String d_nm1 = "";						
					
						if(String.valueOf(ht.get("ACTN_ID")).equals("000000")){			d_nm1 = "매입옵션";						
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("111111")){		d_nm1 = "수의/폐차";						
						}else if(String.valueOf(ht.get("ACTN_ID")).equals("999999")){		d_nm1 = "폐차";	
						}
						
						cnt10[3] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT")));			
					
					amt10[3] 	= AddUtil.parseLong(String.valueOf(ht.get("AMT")));  
					amt20[3] 	= AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));  		
						
		 %>	
				
          <tr>           
            <%if(car_type_cnt==0){%>
             <th align="center" width='60' rowspan='<%=car_type_size4 +1 %>'>렌트</th>
		    <%}%>
            <th align="center" width="110" height="20">&nbsp;&nbsp;<%=d_nm1%></th>        
            <th align="right" height="20" width="60"><%=ht.get("CNT")%></th>
            <th align="right" height="20" width="90"><%=Util.parseDecimal(amt20[3])%></th>
            <th align="right" height="20" width="90"><%=Util.parseDecimal(amt10[3])%></th>
            <th align="right" height="20" width="80"><% if ( cnt10[3] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(amt10[3]/cnt10[3])%><% } %></th>                          
          </tr>  
         
          <%	
          		car_type_cnt++;
          				
					cnt01[3] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT")));
				
					amt01[3] 	+= AddUtil.parseLong(String.valueOf(ht.get("AMT")));  //2010
					amt02[3] 	+= AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));  //2011			
					
			} } %>
				
          <tr> 
            <th class="title" align="center"    height="20">소계</th>   
            <th class="title"  style="text-align:right" height="20" width="60"><%=cnt01[3]%></th>
            <th class="title"  style="text-align:right" height="20" width="90"><%=Util.parseDecimal(amt02[3])%></th>
            <th class="title"  style="text-align:right" height="20" width="90"><%=Util.parseDecimal(amt01[3])%></th>
            <th class="title"  style="text-align:right" height="20" width="80"><% if ( cnt01[3] == 0 ) {%>0<%} else {%><%=Util.parseDecimal(amt01[3]/cnt01[3])%><% } %></th>     
           </tr>               
               
           <tr> 
            <th class="title_p" align="center"  colspan=2  height="20">리스합계</th>
             <th class="title_p"  style="text-align:right" height="20" width="60"><%=cnt01[0]+cnt01[2]%></th>
            <th class="title_p"  style="text-align:right" height="20" width="90"><%=Util.parseDecimal(amt02[0]+amt02[2])%></th>
             <th class="title_p"  style="text-align:right" height="20" width="90"><%=Util.parseDecimal(amt01[0]+amt01[2])%></th>
            <th class="title_p"  style="text-align:right" height="20" width="80"><% if ( (cnt01[0]+cnt01[2]) == 0 ) {%>0<%} else {%><%=Util.parseDecimal((amt01[0]+amt01[2])/(cnt01[0]+cnt01[2]))%><% } %></td>              
      		 </tr>
          
          <tr> 
            <th class="title_p" align="center"  colspan=2  height="20">렌트합계</th>
             <th class="title_p"  style="text-align:right" height="20" width="60"><%=cnt01[1]+cnt01[3]+cnt01[4]%></th>
            <th class="title_p"  style="text-align:right" height="20" width="90"><%=Util.parseDecimal(amt02[1]+amt02[3] +amt02[4])%></th>
              <th class="title_p"  style="text-align:right" height="20" width="90"><%=Util.parseDecimal(amt01[1]+amt01[3] +amt01[4])%></th>
            <th class="title_p"  style="text-align:right" height="20" width="80"><% if ( (cnt01[1]+cnt01[3]+cnt01[4]) == 0 ) {%>0<%} else {%><%=Util.parseDecimal((amt01[1]+amt01[3]+amt01[4])/(cnt01[1]+cnt01[3] +cnt01[4]))%><% } %></th> 
           </tr>
               
          <tr> 
            <th class="title_p" align="center"  colspan=2  height="20">총계</th>
           <th class="title_p"  style="text-align:right" height="20" width="60"><%=cnt01[0]+cnt01[1]+cnt01[2]+cnt01[3]+cnt01[4]%></th>
            <th class="title_p"  style="text-align:right" height="20" width="90"><%=Util.parseDecimal(amt02[0]+amt02[1]+amt02[2]+amt02[3] +amt02[4])%></th>
             <th class="title_p"  style="text-align:right" height="20" width="90"><%=Util.parseDecimal(amt01[0]+amt01[1]+amt01[2]+amt01[3] +amt01[4])%></th>
            <th class="title_p"  style="text-align:right" height="20" width="80"><% if ( (cnt01[0]+cnt01[1]+cnt01[2]+cnt01[3]+cnt01[4]) == 0 ) {%>0<%} else {%><%=Util.parseDecimal((amt01[0]+amt01[1]+amt01[2]+amt01[3]+amt01[4])/(cnt01[0]+cnt01[1]+cnt01[2]+cnt01[3] +cnt01[4]))%><% } %></th> 
          </tr>
      
		</table>		
	</div>	
	<div id="footer"></div>     
</div>			
</form>

</body>
</html>
