<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.insur.*, acar.common.*, acar.res_search.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//브라우저가 크롬일 경우 판별		2018.02.09
	String ua = request.getHeader("User-Agent");
	boolean isChrome = false;
	if(ua.contains("Chrome")){
		isChrome = true;
	}

	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 		= request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");	
	String brch_id 		= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt 	= request.getParameter("start_dt")==null?"":AddUtil.ChangeString(request.getParameter("start_dt"));
	String end_dt 		= request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc 		= request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	int s_year 		= request.getParameter("s_year")==null?0:Util.parseDigit(request.getParameter("s_year"));
	String s_kd 		= request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")==null?"1":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"asc":request.getParameter("asc");
	int sh_height 		= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이	
	String cjgubun = request.getParameter("cjgubun")==null?"all":request.getParameter("cjgubun");
		
	if(s_kd.equals("2")) t_wd = AddUtil.replace(t_wd, "-", ""); //날짜 검색일때 '-' 없애기	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	InsComDatabase inc_db = InsComDatabase .getInstance();
	
	Vector conts = rs_db.getRentPrepareList2(br_id, gubun1, gubun2, brch_id, start_dt, end_dt, car_comp_id, code, s_cc, s_year, s_kd, t_wd, sort_gubun, asc, cjgubun);
	int cont_size = conts.size();	
	
	//업무지원,매각예정 제외 지점별 평균가동율 구하기
	int s1_use_per = 0;
	int b1_use_per = 0;
	int d1_use_per = 0;
	int j1_use_per = 0;
	int g1_use_per = 0;
	int s1_use_cnt = 0;
	int b1_use_cnt = 0;
	int d1_use_cnt = 0;
	int j1_use_cnt = 0;
	int g1_use_cnt = 0;
	
	//보유차 통계(상태)
	int m_rent_1 = 0;
	int d_rent_1 = 0;
	int b_rent_1 = 0;
	int g_rent_1 = 0;
	int j_rent_1 = 0;
	int s_rent_1 = 0;
	int u_rent_1 = 0;
	
	int wei_1 = 0;
	int rev_1 = 0;
	int car_j_1 = 0;
	int car_s_1 = 0;
	
	int status_total_1 = 0;
	int m_wei_1 = 0;
	int total_1 = 0;
	
	//보유차 통계(계약확정)
	int m_rent_2_1 = 0;
	int d_rent_2_1 = 0;
	int b_rent_2_1 = 0;
	int g_rent_2_1 = 0;
	int j_rent_2_1 = 0;
	int s_rent_2_1 = 0;
	int u_rent_2_1 = 0;
	
	int wei_2_1 = 0;
	int rev_2_1 = 0;
	int car_j_2_1 = 0;
	int car_s_2_1 = 0;
	
	int status_total_2_1 = 0;
	int m_wei_2_1 = 0;
	int total_2_1 = 0;
	
	//보유차 통계(상담)
	int m_rent_2_2 = 0;
	int d_rent_2_2 = 0;
	int b_rent_2_2 = 0;
	int g_rent_2_2 = 0;
	int j_rent_2_2 = 0;
	int s_rent_2_2 = 0;
	int u_rent_2_2 = 0;
	
	int wei_2_2 = 0;
	int rev_2_2 = 0;
	int car_j_2_2 = 0;
	int car_s_2_2 = 0;
	
	int status_total_2_2 = 0;
	int m_wei_2_2 = 0;
	int total_2_2 = 0;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="javascript">
<!--
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}			
	
	//팝업윈도우 열기
	function parking_car(car_mng_id, io_gubun, st)
	
	{
		window.open("/fms2/park_home/parking_check_frame.jsp?car_mng_id="+car_mng_id+"&io_gubun="+io_gubun+"&st="+st, "PARKING_CAR", "left=100, top=20, width=1000, height=900, scrollbars=auto");
	}
	
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form name='form1' method='post' target='d_content' action='car_res_list.jsp'>
 <input type='hidden' name='s_cd' value=''>
 <input type='hidden' name='c_id' value=''>
 <input type='hidden' name='rent_st' value=''>  
 <input type='hidden' name='rent_start_dt' value=''> 
 <input type='hidden' name='rent_end_dt' value=''>  
 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
 <input type='hidden' name='gubun1' value='<%=gubun1%>'>  
 <input type='hidden' name='gubun2' value='<%=gubun2%>'>   
 <input type='hidden' name='brch_id' value='<%=brch_id%>'> 
 <input type='hidden' name='start_dt' value='<%=start_dt%>'> 
 <input type='hidden' name='end_dt' value='<%=end_dt%>'>   
 <input type='hidden' name='car_comp_id' value='<%=car_comp_id%>'>   
 <input type='hidden' name='code' value='<%=code%>'>     
 <input type='hidden' name='s_kd'  value='<%=s_kd%>'>
 <input type='hidden' name='t_wd' value='<%=t_wd%>'>			 
 <input type='hidden' name='s_cc' value='<%=s_cc%>'>
 <input type='hidden' name='s_year' value='<%=s_year%>'> 
 <input type='hidden' name='sort_gubun' value="<%=sort_gubun%>"> 
 <input type='hidden' name='sh_height' value="<%=sh_height%>"> 	 
 <input type='hidden' name='asc' value='<%=asc%>'> 	  	
 <input type='hidden' name='mode' value=''> 	  
 <input type='hidden' name='cjgubun' value='<%=cjgubun%>'> 		
<table border="0" cellspacing="0" cellpadding="0" width='1630'>
    <tr><td class=line2 colspan="2"></td></tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='640' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='30' class='title'>연번</td>
                    <td width='30' class='title'>선택</td>
                    <td width='65' class='title'>구분</td>		  
                    <td width='55' class='title'>지점</td>
                    <td width='55' class='title'>상담</td>                    
                    <td width='60' class='title'>이용상태</td>
                    <td width='55' class='title'>차량상태</td>
					<td width='80' class='title'>현위치</td>		  		  
                    <td width='120' class='title'>차량번호</td>		  		  
                    <td width='90' class='title'>차명</td>
                </tr>
            </table>
    	</td>
    	<td class='line' width='990'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
        		    <td width='50' class='title'>배기량</td>
        		    <td width='60' class='title'>연료</td>
        		    <td width='80' class='title'>칼라</td>		  
        		    <td width='90' class='title'>최초등록일</td>
        		    <td width='50' class='title'>차령</td>	
        		    <td width='70' class='title'>자산양수</td>		  				
        		    <td width='45' class='title'>경과일</td>		  
        		    <td width='45' class='title'>가동율</td>     
        		    <td width='70' class='title'>주행거리</td>					
        		    <td width='70' class='title'>단기대여</td>
        		    <td width='70' class='title'>정비대차</td>
        		    <td width='70' class='title'>단기대비</td>
			    <td width='70' class='title'>해지반납일</td>					   
        		    <td width='50' class='title'>보험</td>
        		    <td width='50' class='title'>임직원</td>
        		    <td width='50' class='title'>담당자</td>
        		    <!--<td width='90' class='title'>반차스케줄</td>-->
        		</tr>
    	    </table>
    	</td>
    </tr>
<%	if(cont_size > 0){	%>  
    <tr>
	    <td class='line' width='620' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable reserv = (Hashtable)conts.elementAt(i);				
				String use_per_car = "Y";
				int ex_count = inc_db.getCheckConfCnt(String.valueOf(reserv.get("CAR_MNG_ID")));
				if(ex_count > 0) continue;
				
				if(String.valueOf(reserv.get("PREPARE")).equals("매각예정")){
					use_per_car = "N";
				}			
				if(String.valueOf(reserv.get("RENT_ST_NM")).equals("업무대여")){
					use_per_car = "N";
				}					
				if(use_per_car.equals("Y")){					
					int use_per = 0;					
					if(String.valueOf(reserv.get("PREPARE")).equals("말소") || String.valueOf(reserv.get("PREPARE")).equals("도난") || String.valueOf(reserv.get("PREPARE")).equals("수해")){
						use_per = 100;
					}else{
						if(AddUtil.parseInt(String.valueOf(reserv.get("USE_PER"))) > 100){
							use_per = 100;
						}else{
							use_per = AddUtil.parseInt(String.valueOf(reserv.get("USE_PER")));
						}
					}
					if(String.valueOf(reserv.get("BRCH_NM")).equals("본사")){
						s1_use_cnt++;
						s1_use_per = s1_use_per + use_per;
					}else if(String.valueOf(reserv.get("BRCH_NM")).equals("부산지점")){
						b1_use_cnt++;
						b1_use_per = b1_use_per + use_per;
					}else if(String.valueOf(reserv.get("BRCH_NM")).equals("대전지점")){
						d1_use_cnt++;
						d1_use_per = d1_use_per + use_per;
					}else if(String.valueOf(reserv.get("BRCH_NM")).equals("광주지점")){
						j1_use_cnt++;
						j1_use_per = j1_use_per + use_per;
					}else if(String.valueOf(reserv.get("BRCH_NM")).equals("대구지점")){
						g1_use_cnt++;
						g1_use_per = g1_use_per + use_per;
					}						
				}
				
				
				
				if (String.valueOf(reserv.get("USE_ST")).equals("2")) {
					//월렌트
					if (String.valueOf(reserv.get("RENT_ST")).equals("12")) {
						m_rent_1++;
						
						if (String.valueOf(reserv.get("SITUATION")).equals("계약확정")) {
							m_rent_2_1++;
						}
						if (String.valueOf(reserv.get("SITUATION")).equals("상담중")) {
							m_rent_2_2++;
						}
					}
					//단기대여
					if (String.valueOf(reserv.get("RENT_ST")).equals("1")) {
						d_rent_1++;
						
						if (String.valueOf(reserv.get("SITUATION")).equals("계약확정")) {
							d_rent_2_1++;
						}
						if (String.valueOf(reserv.get("SITUATION")).equals("상담중")) {
							d_rent_2_2++;
						}
					}
					//보험대차
					if (String.valueOf(reserv.get("RENT_ST")).equals("9")) {
						b_rent_1++;
						
						if (String.valueOf(reserv.get("SITUATION")).equals("계약확정")) {
							b_rent_2_1++;
						}
						if (String.valueOf(reserv.get("SITUATION")).equals("상담중")) {
							b_rent_2_2++;
						}
					}
					//지연대차
					if (String.valueOf(reserv.get("RENT_ST")).equals("10")) {
						g_rent_1++;
						
						if (String.valueOf(reserv.get("SITUATION")).equals("계약확정")) {
							g_rent_2_1++;
						}
						if (String.valueOf(reserv.get("SITUATION")).equals("상담중")) {
							g_rent_2_2++;
						}
					}
					//정비대차
					if (String.valueOf(reserv.get("RENT_ST")).equals("2")) {
						j_rent_1++;
						
						if (String.valueOf(reserv.get("SITUATION")).equals("계약확정")) {
							j_rent_2_1++;
						}
						if (String.valueOf(reserv.get("SITUATION")).equals("상담중")) {
							j_rent_2_2++;
						}
					}
					//사고대차
					if (String.valueOf(reserv.get("RENT_ST")).equals("3")) {
						s_rent_1++;
						
						if (String.valueOf(reserv.get("SITUATION")).equals("계약확정")) {
							s_rent_2_1++;
						}
						if (String.valueOf(reserv.get("SITUATION")).equals("상담중")) {
							s_rent_2_2++;
						}
					}
					//업무대여
					if (String.valueOf(reserv.get("RENT_ST")).equals("4") || String.valueOf(reserv.get("RENT_ST")).equals("5")) {
						u_rent_1++;
						
						if (String.valueOf(reserv.get("SITUATION")).equals("계약확정")) {
							u_rent_2_1++;
						}
						if (String.valueOf(reserv.get("SITUATION")).equals("상담중")) {
							u_rent_2_2++;
						}
					}
					//차량정비
					if (String.valueOf(reserv.get("RENT_ST")).equals("6") || String.valueOf(reserv.get("RENT_ST")).equals("7")) {
						car_j_1++;
						
						if (String.valueOf(reserv.get("SITUATION")).equals("계약확정")) {
							car_j_2_1++;
						}
						if (String.valueOf(reserv.get("SITUATION")).equals("상담중")) {
							car_j_2_2++;
						}
					}
					//사고수리
					if (String.valueOf(reserv.get("RENT_ST")).equals("8")) {
						car_s_1++;
						
						if (String.valueOf(reserv.get("SITUATION")).equals("계약확정")) {
							car_s_2_1++;
						}
						if (String.valueOf(reserv.get("SITUATION")).equals("상담중")) {
							car_s_2_2++;
						}
					}
				} else if (String.valueOf(reserv.get("USE_ST")).equals("1")) {
					//예약
					rev_1++;
					
					if (String.valueOf(reserv.get("SITUATION")).equals("계약확정")) {
						rev_2_1++;
					}
					if (String.valueOf(reserv.get("SITUATION")).equals("상담중")) {
						rev_2_2++;
					}
					
				} else {
					//대기
					if (String.valueOf(reserv.get("PREPARE")).equals("예비") && String.valueOf(reserv.get("CAR_STAT")).equals("대기")) {
						wei_1++;
						
						if (String.valueOf(reserv.get("SITUATION")).equals("계약확정")) {
							wei_2_1++;
						}
						if (String.valueOf(reserv.get("SITUATION")).equals("상담중")) {
							wei_2_2++;
						}
					}
					//매각예정
					if (String.valueOf(reserv.get("PREPARE")).equals("매각예정")) {
						m_wei_1++;
						
						if (String.valueOf(reserv.get("SITUATION")).equals("계약확정")) {
							m_wei_2_1++;
						}
						if (String.valueOf(reserv.get("SITUATION")).equals("상담중")) {
							m_wei_2_2++;
						}
					}
				}
				
				%>	
                <tr> 
                  <td width='30' align='center'><%=i+1%></td>
                  <!--선택-->
                  <td width='30' align='center'>
		    <%if(String.valueOf(reserv.get("CALL_IN_DT")).equals("")){//임시회수제외%>
			<input type="checkbox" name="pr" value="<%=reserv.get("CAR_MNG_ID")%>^<%=reserv.get("PARK")%>^<%=reserv.get("CAR_NO")%>">
		    <%}%>
		  </td>		  
                  <!--구분(예비,매각예정)-->
                  <td width='65' align='center'>
					
					
        	    <%if(String.valueOf(reserv.get("PREPARE")).equals("예비")){%>
                      <font color="#999999">                      	  
						<%if(nm_db.getWorkAuthUser("본사관리팀장",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) ){%>
							<%if(!String.valueOf(reserv.get("RM_YN")).equals("N")){%>
							M
							<%}%>
						<%}%>
						
                        <%if(String.valueOf(reserv.get("SECONDHAND")).equals("1")){%>
                      	  <span title="재리스 등록 차량"><%=reserv.get("PREPARE")%>S</span>
                      	<%}else{%>
                      	  <%=reserv.get("PREPARE")%>
                      	<%}%>
                      	
                      </font> 
                    <%}else{%>
                      <font color="red"><%=reserv.get("PREPARE")%></font> 
                    <%}%>		  
					
        	  </td>
        	  <!--지점-->
                  <td width='55' align='center'><%=reserv.get("BRCH_NM")%></td>		  
                  <!--상담-->
                  <td width='55' align='center'>		  
                    <%if(String.valueOf(reserv.get("SITUATION")).equals("계약확정") || String.valueOf(reserv.get("SITUATION")).equals("상담중")){%>
		      <span title="[<%=reserv.get("SITUATION_DT")%>]<%=reserv.get("DAMDANG")%>:<%=reserv.get("MEMO")%>"><%=reserv.get("SITUATION")%></span>
		    <%}else{%>
		      -
		    <%}%>					          			  	
        	  </td>	
                  <!--이용상태-->
                  <td width='60' align='center'>		  
                    <%if(String.valueOf(reserv.get("CAR_STAT")).equals("예약")){%>
		      <span title='[<%=reserv.get("RENT_ST_NM")%>]<%=reserv.get("BUS_NM")%>:<%=reserv.get("FIRM_NM")%> <%=reserv.get("CUST_NM")%> <%=reserv.get("RENT_START_DT")%>'>예약</span>
                    <%}else if(String.valueOf(reserv.get("CAR_STAT")).equals("대기")){%>			  
                      -
                    <%}else{%>
        	      <%=reserv.get("RENT_ST_NM")%> 
                    <%}%>
        	  </td>	
        	  <!--차량상태-->
                  <td width='55' align='center'>
                      <%//if(String.valueOf(reserv.get("CAR_USE")).equals("1")){%>		  		    
		        <%//if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	  
        	          <a class=index1 href="javascript:MM_openBrWindow('car_rmst.jsp?c_id=<%=reserv.get("CAR_MNG_ID")%>&car_no=<%=reserv.get("CAR_NO")%>&auth_rw=<%=auth_rw%>','CarRmSt','scrollbars=no,status=yes,resizable=yes,width=420,height=530,left=50, top=50')" title='<%=reserv.get("CHECK_DT")%>'>
		        <%//}%>        	        
        	        <%if(String.valueOf(reserv.get("RM_ST")).equals("정비요") ){%><font color='red'><%}%>
        	        <%if(String.valueOf(reserv.get("RM_ST")).equals("미확인")){%><font color='green'><%}%>
        		<%=reserv.get("RM_ST")%>
        		<%if(String.valueOf(reserv.get("RM_ST")).equals("정비요") || String.valueOf(reserv.get("RM_ST")).equals("점검요")){%></font><%}%>        	        
		        <%//if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	  
        		  </a>		
		        <%//}%>
		      <%//}%>
        	  </td>	
        	  <!--현위치,운행내용-->	  
                  <td width='80' align='center'>
        			  <%if(String.valueOf(reserv.get("CAR_STAT")).equals("-") || String.valueOf(reserv.get("CAR_STAT")).equals("대기") || String.valueOf(reserv.get("CAR_STAT")).equals("예약")){%>		
					      <%//	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	  
        	              <a class=index1 href="javascript:MM_openBrWindow('car_park.jsp?c_id=<%=reserv.get("CAR_MNG_ID")%>&car_no=<%=reserv.get("CAR_NO")%>&brch_id=<%=String.valueOf(reserv.get("BRCH_ID"))%>&mng_br_id=<%=String.valueOf(reserv.get("MNG_BR_ID"))%>&auth_rw=<%=auth_rw%>','CarPark','scrollbars=no,status=yes,resizable=yes,width=420,height=200,left=50, top=50')">
						  <%//	}%>
        				  <%if(String.valueOf(reserv.get("PARK")).equals("")){%>
        				  등록
        				  <%}else{%>
        				  <% if (reserv.get("PARK").equals("신엠제이모터스")) { %>
        				  			<span title="<%=reserv.get("PARK")%>"><%=Util.subData(String.valueOf(reserv.get("PARK")), 4)%></span>
        				  <% } else { %>
			        				  <%=Util.subData(String.valueOf(reserv.get("PARK")), 5)%>
        				  <% } %>
        				  <font color=red><%=reserv.get("PARK_YN")%></font>
        	          		  
        			  	  <%}%>
						  <%//	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	  
        				  </a>		
						  <%//	}%>						  	  
                      <%}else{%>
        			      <font color="#999999">
                          <%if(String.valueOf(reserv.get("RENT_ST_NM")).equals("업무대여")){%>
        				  	<span title='<%=reserv.get("CUST_NM")%>'><%=Util.subData(String.valueOf(reserv.get("CUST_NM")), 5)%></span>				  
                          <%}else{%>
        				  	<span title='<%=reserv.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(reserv.get("FIRM_NM")), 5)%></span><font color=red><%=reserv.get("PARK_YN")%></font>
        				  <%}%>
        				  </font>
                      <%}%>
        		  </td>		  
                  <td width='120' align='center'>
                    	<a href="javascript:parent.car_reserve('<%=reserv.get("RENT_S_CD")%>', '<%=reserv.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true">
                      	<%if(String.valueOf(reserv.get("A_CNT")).equals("0")){//수해경력없음%>
                      	<%	if(String.valueOf(reserv.get("SORT_CODE")).equals("")){//매각검토차량 아님%>
                      			<%=reserv.get("CAR_NO")%>
			<%	}else{//매각검토차량%>
                      			<font color="green"><%=reserv.get("CAR_NO")%></font> 																		
			<%	}%>		  
                      	<%}else{//수해차량%>			  
                      			<font color="#ff8200"><%=reserv.get("CAR_NO")%></font> 						
                        <%}%>							
							</a>
						&nbsp; 
						<a href="javascript:parking_car('<%=reserv.get("CAR_MNG_ID")%>', '1', '1')" onMouseOver="window.status=''; return true" hover><img src="http://fms1.amazoncar.co.kr/acar/images/center/icon_memo.gif"  align="absmiddle" border="0"></a>
        			&nbsp;
        				<%if(!String.valueOf(reserv.get("PIC_CNT")).equals("0")){%>            		        
                        <a class=index1 href="javascript:MM_openBrWindow('/acar/secondhand_hp/bigimg.jsp?c_id=<%=reserv.get("CAR_MNG_ID")%>','popwin0','scrollbars=no,status=no,resizable=yes,width=800,height=600,left=50, top=50')" title='등록일:<%=reserv.get("PIC_REG_DT")%>' ><img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0"></a>
				      <% } else {%><%if(isChrome){%>&nbsp;&nbsp; <%}else{%><!-- 크롬일 경우 리스트 깨지는 현상 수정 2018.02.09 -->
				      	&nbsp;	&nbsp;	&nbsp;
                  <%}%><%}%>		
        			
        		  </td>
                  <td width='90' align='center'><span title='<%=reserv.get("CAR_NM")+" "+reserv.get("CAR_NAME")%>'><%=AddUtil.substringbdot(String.valueOf(reserv.get("CAR_NM")+" "+reserv.get("CAR_NAME")), 10)%></span></td>		  
                </tr>
        <%	}%>
            </table>
	    </td>
	    <td class='line' width='990'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable reserv = (Hashtable)conts.elementAt(i);
				
				int ex_count = inc_db.getCheckConfCnt(String.valueOf(reserv.get("CAR_MNG_ID")));
				if(ex_count > 0) continue;
				
				%>			
                <tr>
                    <td width='50' align="right"><%=reserv.get("DPM")%>cc</td>
                    <td width='60' align="center"> <%=Util.subData(String.valueOf(reserv.get("FUEL_KD")), 4)%></td>
                    <td width='80' align="center"><span title="<%=reserv.get("COLO")%>"><%=Util.subData(String.valueOf(reserv.get("COLO")), 5)%></span></td>
                    <td width="90" align='center'><%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
                    <td width="50" align='right'><%=reserv.get("USE_MON")%>개월</td>			
                    <td width="70" align='center'><%=reserv.get("SSS")%></td>											
		   				 <td width="45" align='right'><%=reserv.get("DAY")%>일</td>											
                    <td width='45' align="right"><font color="#FF0000">
        			  <%if(String.valueOf(reserv.get("PREPARE")).equals("말소") || String.valueOf(reserv.get("PREPARE")).equals("도난") || String.valueOf(reserv.get("PREPARE")).equals("수해")){%>
        			  100
        			  <%}else{%>
                      	<%if(AddUtil.parseInt(String.valueOf(reserv.get("USE_PER"))) > 100){%>
                      	100
                      	<%}else{%>
                      	<%=String.valueOf(reserv.get("USE_PER"))%>
                      	<%}%>
                      <%}%>			  
                      %</font></td>
                    <td width="70" align='right'><%=Util.parseDecimal(String.valueOf(reserv.get("TODAY_DIST")))%>km</td>	
                    <td width="70" align='right'><%=Util.parseDecimal(String.valueOf(reserv.get("AMT_01D")))%></td>	
                    <td width='70' align="right">
                        <%if(String.valueOf(reserv.get("CAR_USE")).equals("1")){%><font color="#000000"><%}else{%><font color="#999999"><%}%>					    
                        <span title='[일반대차] 월대여료 : <%=Util.parseDecimal(String.valueOf(reserv.get("FEE_AMT")))%> (vat포함)'><%=Util.parseDecimal(String.valueOf(reserv.get("DAY_AMT")))%></span>
                        </font>
                    </td>	
                    <td width="70" align='right'><%=String.valueOf(reserv.get("SF_AMT_PER"))%>%</td>	
                    <td width="70" align='center'><%=reserv.get("CALL_IN_DT")%></td>																														  										  
                    <td width="50" align='center'><%=Util.subData(String.valueOf(reserv.get("CON_F_NM")), 6)%> <%=reserv.get("AGE_ST")%></td>			
                     <td width="50" align='center'><%=reserv.get("COM_EMP_YN")%></td>														  
                    <td width="50" align='center'><%=reserv.get("MNG_NM")%></td>	
                </tr>
		<%	}%>
	        </table>
	    </td>
<%	}else{	%>                     
    <tr>		
        <td class='line' width='640' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>등록된 데이타가 없습니다</td>
                </tr>
            </table>
    	</td>
    	<td class='line' width='990'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
        		    <td>&nbsp;</td>
        		</tr>
    	    </table>
	    </td>
    </tr>
<%	}	%>
</form>
<script language='javascript'>
<!--
	parent.document.form1.s1_use_avg_per.value = '<%=AddUtil.parseFloatCipher(String.valueOf(AddUtil.parseFloat(String.valueOf(s1_use_per))/AddUtil.parseFloat(String.valueOf(s1_use_cnt))), 1)%>';
	parent.document.form1.b1_use_avg_per.value = '<%=AddUtil.parseFloatCipher(String.valueOf(AddUtil.parseFloat(String.valueOf(b1_use_per))/AddUtil.parseFloat(String.valueOf(b1_use_cnt))), 1)%>';
	parent.document.form1.d1_use_avg_per.value = '<%=AddUtil.parseFloatCipher(String.valueOf(AddUtil.parseFloat(String.valueOf(d1_use_per))/AddUtil.parseFloat(String.valueOf(d1_use_cnt))), 1)%>';
	parent.document.form1.j1_use_avg_per.value = '<%=AddUtil.parseFloatCipher(String.valueOf(AddUtil.parseFloat(String.valueOf(j1_use_per))/AddUtil.parseFloat(String.valueOf(j1_use_cnt))), 1)%>';
	parent.document.form1.g1_use_avg_per.value = '<%=AddUtil.parseFloatCipher(String.valueOf(AddUtil.parseFloat(String.valueOf(g1_use_per))/AddUtil.parseFloat(String.valueOf(g1_use_cnt))), 1)%>';
	
	parent.document.form1.m_rent_1.value = '<%=String.valueOf(m_rent_1)%>';
	parent.document.form1.d_rent_1.value = '<%=String.valueOf(d_rent_1)%>';
	parent.document.form1.b_rent_1.value = '<%=String.valueOf(b_rent_1)%>';
	parent.document.form1.g_rent_1.value = '<%=String.valueOf(g_rent_1)%>';
	parent.document.form1.j_rent_1.value = '<%=String.valueOf(j_rent_1)%>';
	parent.document.form1.s_rent_1.value = '<%=String.valueOf(s_rent_1)%>';
	parent.document.form1.u_rent_1.value = '<%=String.valueOf(u_rent_1)%>';
	
	parent.document.form1.wei_1.value = '<%=String.valueOf(wei_1)%>';
	parent.document.form1.rev_1.value = '<%=String.valueOf(rev_1)%>';	
	parent.document.form1.car_j_1.value = '<%=String.valueOf(car_j_1)%>';
	parent.document.form1.car_s_1.value = '<%=String.valueOf(car_s_1)%>';
	
	parent.document.form1.status_total_1.value = '<%=String.valueOf(m_rent_1 + d_rent_1 + b_rent_1 + g_rent_1 + j_rent_1 + s_rent_1 + u_rent_1 + wei_1 + rev_1 + car_j_1 + car_s_1)%>';
	parent.document.form1.m_wei_1.value = '<%=String.valueOf(m_wei_1)%>';	
	parent.document.form1.total_sum_1.value = '<%=String.valueOf(m_rent_1 + d_rent_1 + b_rent_1 + g_rent_1 + j_rent_1 + s_rent_1 + u_rent_1 + wei_1 + rev_1 + car_j_1 + car_s_1 + m_wei_1)%>';
	
	
	
	parent.document.form1.m_rent_2.value = '<%=String.valueOf(m_rent_2_1)%>/<%=String.valueOf(m_rent_2_2)%>';
	parent.document.form1.d_rent_2.value = '<%=String.valueOf(d_rent_2_1)%>/<%=String.valueOf(d_rent_2_2)%>';
	parent.document.form1.b_rent_2.value = '<%=String.valueOf(b_rent_2_1)%>/<%=String.valueOf(b_rent_2_2)%>';
	parent.document.form1.g_rent_2.value = '<%=String.valueOf(g_rent_2_1)%>/<%=String.valueOf(g_rent_2_2)%>';
	parent.document.form1.j_rent_2.value = '<%=String.valueOf(j_rent_2_1)%>/<%=String.valueOf(j_rent_2_2)%>';
	parent.document.form1.s_rent_2.value = '<%=String.valueOf(s_rent_2_1)%>/<%=String.valueOf(s_rent_2_2)%>';
	parent.document.form1.u_rent_2.value = '<%=String.valueOf(u_rent_2_1)%>/<%=String.valueOf(u_rent_2_2)%>';
	
	parent.document.form1.wei_2.value = '<%=String.valueOf(wei_2_1)%>/<%=String.valueOf(wei_2_2)%>';
	parent.document.form1.rev_2.value = '<%=String.valueOf(rev_2_1)%>/<%=String.valueOf(rev_2_2)%>';	
	parent.document.form1.car_j_2.value = '<%=String.valueOf(car_j_2_1)%>/<%=String.valueOf(car_j_2_2)%>';
	parent.document.form1.car_s_2.value = '<%=String.valueOf(car_s_2_1)%>/<%=String.valueOf(m_rent_1)%>';
	
	parent.document.form1.status_total_2.value = '<%=String.valueOf(m_rent_2_1 + d_rent_2_1 + b_rent_2_1 + g_rent_2_1 + j_rent_2_1 + s_rent_2_1 + u_rent_2_1 + wei_2_1 + rev_2_1 + car_j_2_1 + car_s_2_1)%>/<%=String.valueOf(m_rent_2_2 + d_rent_2_2 + b_rent_2_2 + g_rent_2_2 + j_rent_2_2 + s_rent_2_2 + u_rent_2_2 + wei_2_2 + rev_2_2 + car_j_2_2 + car_s_2_2)%>';
	parent.document.form1.m_wei_2.value = '<%=String.valueOf(m_wei_2_1)%>/<%=String.valueOf(m_wei_2_2)%>';	
	parent.document.form1.total_sum_2.value = '<%=String.valueOf(m_rent_2_1 + d_rent_2_1 + b_rent_2_1 + g_rent_2_1 + j_rent_2_1 + s_rent_2_1 + u_rent_2_1 + wei_2_1 + rev_2_1 + car_j_2_1 + car_s_2_1 + m_wei_2_1)%>/<%=String.valueOf(m_rent_2_2 + d_rent_2_2 + b_rent_2_2 + g_rent_2_2 + j_rent_2_2 + s_rent_2_2 + u_rent_2_2 + wei_2_2 + rev_2_2 + car_j_2_2 + car_s_2_2 + m_wei_2_2)%>';
//-->
</script>
</body>
</html>
