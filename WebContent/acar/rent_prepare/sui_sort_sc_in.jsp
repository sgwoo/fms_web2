<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code 	= request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc 	= request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	int s_year 		= request.getParameter("s_year")==null?0:Util.parseDigit(request.getParameter("s_year"));
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이	
	
	
	if(s_kd.equals("2")) t_wd = AddUtil.replace(t_wd, "-", ""); //날짜 검색일때 '-' 없애기
	
	
	
	Vector conts = rs_db.getSuiSortCarList(br_id, gubun1, gubun2, brch_id, start_dt, end_dt, car_comp_id, code, s_cc, s_year, s_kd, t_wd, sort_gubun, asc);
	int cont_size = conts.size();
%>

<html>
<head>
<title>FMS</title>
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
 <input type='hidden' name='from_page' value='/acar/rent_prepare/sui_sort_sc.jsp'> 	  		
<table border="0" cellspacing="0" cellpadding="0" width='1510'>
    <tr><td class=line2 colspan="2"></td></tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='520' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='30' class='title' style='height:51'>연번</td>
                    <td width='30' class='title'>선택</td>
                    <td width='60' class='title'>구분</td>		  
                    <td width='60' class='title'>지점</td>
                    <td width='60' class='title'>상태</td>
        		    <td width='80' class='title'>현위치</td>		  		  
                    <td width='90' class='title'>차량번호</td>		  		  
                    <td width='110' class='title'>차명</td>
                </tr>
            </table>
    	</td>
    	<td class='line' width='990'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
        		    <td width='70' rowspan="2" class='title'>최초등록일</td>				
        		    <td width='45' rowspan="2" class='title'>경과일</td>																								
        		    <td width='45' rowspan="2" class='title'>차령</td>				
        		    <td width='65' rowspan="2" class='title'>주행거리</td>				
        		    <td width='45' rowspan="2" class='title'>가동율</td>
					<td width='45' rowspan="2" class='title'>재리스<br>상담</td>
        		    <td class='title'>기준1</td>
					<td class='title'>기준2</td>
        		    <td colspan="4" class='title'>기준3</td>					
        		    <td colspan="2" class='title'>수출효과</td>
        		    <td width='150' rowspan="2" class='title'>선별기준</td>
        		    <td width='70' rowspan="2" class='title'>마감일자</td>									
        		</tr>
        		<tr>
        		  <td width='40' class='title'>차령</td>
       		      <td width="60" class='title'>주행거리</td>				  
       		      <td width="50" class='title'>경과일</td>
				  <td width="40" class='title'>차령</td>
       		      <td width='60' class='title'>주행거리</td>
       		      <td width='50' class='title'>가동율</td>
       		      <td width='85' class='title'>금액</td>
       		      <td width='70' class='title'>견적일</td>
       		  </tr>
    	    </table>
    	</td>
    </tr>
<%	if(cont_size > 0){	%>  
    <tr>
	    <td class='line' width='520' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable reserv = (Hashtable)conts.elementAt(i);%>	
                <tr> 
                  <td width='30' align='center'><%=i+1%> </td>
                  <td width='30' align='center'>
				  	<%if(String.valueOf(reserv.get("OFF_LS")).equals("예비차량") && String.valueOf(reserv.get("USE_YN")).equals("Y") && String.valueOf(reserv.get("CAR_ST")).equals("2") && String.valueOf(reserv.get("REG_DT")).equals(AddUtil.getDate(4))){%>	
				      <input type="checkbox" name="pr" value="<%=reserv.get("CAR_MNG_ID")%>">
					<%}%>  
				  </td>		  
                  <td width='60' align='center'>
				  	  <%if(String.valueOf(reserv.get("OFF_LS")).equals("예비차량")){%>
        			  	<%if(String.valueOf(reserv.get("PREPARE")).equals("예비")){%>
                      	<font color="#999999">                      	  
							<%if(String.valueOf(reserv.get("SECONDHAND")).equals("1")){%>
                      	  	<span title="재리스 등록 차량">
                      		<%}%>
                      		<%=reserv.get("PREPARE")%>
							<%if(String.valueOf(reserv.get("SECONDHAND")).equals("1")){%>						
							</span>
                      		<%}%>
					  	</font> 
                      	<%}else{%>
                      	<font color="red"><%=reserv.get("PREPARE")%></font> 
                      	<%}%>		  
					  <%}else{%>
					    <font color="green"><%=reserv.get("OFF_LS")%></font>
					  <%}%>
        		  </td>
                  <td width='60' align='center'><%=reserv.get("BRCH_NM")%></td>		  
                  <td width='60' align='center'>		  
                      <%if(String.valueOf(reserv.get("CAR_STAT")).equals("예약")){%>
                   	  	<%if(String.valueOf(reserv.get("SITUATION")).equals("계약확정")){%>
						<span title="[<%=reserv.get("SITUATION_DT")%>]<%=reserv.get("DAMDANG")%>:<%=reserv.get("MEMO")%>"><%=reserv.get("SITUATION")%></span>
						<%}else{%>
						<span title="[<%=reserv.get("RENT_ST_NM")%>]<%=reserv.get("BUS_NM")%>:<%=reserv.get("FIRM_NM")%> <%=reserv.get("CUST_NM")%> <%=reserv.get("RENT_START_DT")%>">예약</span>
						<%}%>					          			  	
                      <%}else if(String.valueOf(reserv.get("CAR_STAT")).equals("대기")){%>			  
                   	  	<%if(String.valueOf(reserv.get("SITUATION")).equals("")){%>-<%}else{%><span title="[<%=reserv.get("SITUATION_DT")%>]<%=reserv.get("DAMDANG")%>:<%=reserv.get("MEMO")%>"><%=reserv.get("SITUATION")%></span><%}%>
                      <%}else{%>
        	            <%=reserv.get("RENT_ST_NM")%> 
                      <%}%>
        		  </td>		  
                  <td width='80' align='center'>
        			  <%if(String.valueOf(reserv.get("CAR_STAT")).equals("-") || String.valueOf(reserv.get("CAR_STAT")).equals("대기") || String.valueOf(reserv.get("CAR_STAT")).equals("예약")){%>			  
        	              <a class=index1 href="javascript:MM_openBrWindow('car_park.jsp?c_id=<%=reserv.get("CAR_MNG_ID")%>&car_no=<%=reserv.get("CAR_NO")%>','CarPark','scrollbars=no,status=yes,resizable=yes,width=420,height=200,left=50, top=50')">
        				  <%if(String.valueOf(reserv.get("PARK")).equals("")){%>
        				  등록
        				  <%}else{%>
        				  <%=Util.subData(String.valueOf(reserv.get("PARK")), 5)%>
        	          		  
        			  	  <%}%>
        				  </a>			  
                      <%}else{%>
        			      <font color="#999999">
                          <%if(String.valueOf(reserv.get("RENT_ST_NM")).equals("업무대여")){%>
        				  	<span title='<%=reserv.get("CUST_NM")%>'><%=Util.subData(String.valueOf(reserv.get("CUST_NM")), 5)%></span>				  
                          <%}else{%>
        				  	<span title='<%=reserv.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(reserv.get("FIRM_NM")), 5)%></span>
        				  <%}%>
        				  </font>
                      <%}%>
        		  </td>		  
                  <td width='90' align='center'>
                    	
                      	<%if(String.valueOf(reserv.get("A_CNT")).equals("0")){%>
                      	<a href="javascript:parent.car_reserve('<%=reserv.get("RENT_S_CD")%>', '<%=reserv.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true">
						<%=reserv.get("CAR_NO")%>
						</a>
						<!--&nbsp;<a href="javascript:parking_car('<%=reserv.get("CAR_MNG_ID")%>', '1', '1')" onMouseOver="window.status=''; return true" hover><img src="http://fms1.amazoncar.co.kr/acar/images/center/icon_memo.gif"  align="absmiddle" border="0"></a>-->
                      	<%}else{%>	
						<a href="javascript:parent.car_reserve('<%=reserv.get("RENT_S_CD")%>', '<%=reserv.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true">		  
                      	<font color="#ff8200"><%=reserv.get("CAR_NO")%></font> 
						</a>
                      <%}%>			  
        			</a>
        		  </td>
                  <td width='110' align='center'><span title='<%=reserv.get("CAR_NM")+" "+reserv.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(reserv.get("CAR_NM")+" "+reserv.get("CAR_NAME")), 8)%></span>
				  </td>		  
                </tr>
        <%	}%>
            </table>
	    </td>
	    <td class='line' width='990'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable reserv = (Hashtable)conts.elementAt(i);%>			
                <tr>
                    <td width='70' align="center"><%=reserv.get("INIT_REG_DT")%></td>				
                    <td width='45' align="right"><%=reserv.get("CAR_DAY")%>일</td>
                    <td width='45' align="right"><%=reserv.get("CAR_MON")%>개월</td>
                    <td width='65' align="right"><%=Util.parseDecimal(String.valueOf(reserv.get("CAR_DIST")))%>km</td>
                    <td width="45" align='right'><%=reserv.get("CAR_USE_PER")%>%</td>											
					<td width="45" align='right'><%=reserv.get("SH_RES_CNT")%>건</td>
                    <td width="40" align='right' <%if(String.valueOf(reserv.get("ST1_YN")).equals("Y")){%>class='im'<%}%>><%=reserv.get("B_MON_ONLY")%></td>
                    <td width="60" align="right" <%if(String.valueOf(reserv.get("ST2_YN")).equals("Y")){%>class='im'<%}%>><%=Util.parseDecimal(String.valueOf(reserv.get("B_DIST_ONLY")))%></td>						
                    <td width="50" align='right' <%if(String.valueOf(reserv.get("ST3_YN")).equals("Y")){%>class='im'<%}%>><%=reserv.get("B_DAY")%></td>					
                    <td width="40" align='right' <%if(String.valueOf(reserv.get("ST3_1_YN")).equals("Y")){%>class='im'<%}%>><%=reserv.get("B_MON")%></td>					
                    <td width="60" align="right" <%if(String.valueOf(reserv.get("ST3_2_YN")).equals("Y")){%>class='im'<%}%>><%=Util.parseDecimal(String.valueOf(reserv.get("B_DIST")))%></td>											
                    <td width='50' align="right" <%if(String.valueOf(reserv.get("ST3_3_YN")).equals("Y")){%>class='im'<%}%>><%=reserv.get("B_USE_PER")%></td>
                    <td width='85' align="center"<%if(!String.valueOf(reserv.get("EX_N_H")).equals("")){%>class='im'<%}%>><%=reserv.get("EX_N_H")%></td>
                    <td width='70' align="center"<%if(!String.valueOf(reserv.get("EX_N_H")).equals("")){%>class='im'<%}%>><%=reserv.get("EX_N_H_DT")%></td>
                  	<td width='150' align="center"><span title='<%=reserv.get("SORT_GUBUN")%>'><%=Util.subData(String.valueOf(reserv.get("SORT_GUBUN")), 15)%></span></td>					
                    <td width='70' align="center"><%=reserv.get("REG_DT")%></td>									
                </tr>
		<%	}%>
	        </table>
	    </td>
<%	}else{	%>                     
    <tr>		
        <td class='line' width='520' id='td_con' style='position:relative;'> 
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
</body>
</html>
