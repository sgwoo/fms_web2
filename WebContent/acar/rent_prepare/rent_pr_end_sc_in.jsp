<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

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
//-->
</script>
</head>
<body onLoad="javascript:init()">

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":AddUtil.ChangeString(request.getParameter("start_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	int s_year = request.getParameter("s_year")==null?0:Util.parseDigit(request.getParameter("s_year"));
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"1":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	if(s_kd.equals("2")) t_wd = AddUtil.replace(t_wd, "-", ""); //날짜 검색일때 '-' 없애기
	
	Vector conts = rs_db.getRentPrepareEndList(br_id, gubun1, gubun2, brch_id, start_dt, end_dt, car_comp_id, code, s_cc, s_year, s_kd, t_wd, sort_gubun, asc);
	int cont_size = conts.size();
%>

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
 <input type='hidden' name='asc' value='<%=asc%>'> 	  	
 <input type='hidden' name='mode' value='end'> 	  		
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr><td class=line2 colspan="2"></td></tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='52%' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='7%' class='title'>연번</td>
                    <td width='7%' class='title'>선택</td>
                    <td width='8%' class='title'>구분</td>		  
                    <td width='12%' class='title'>지점</td>
                    <td width='13%' class='title'>상태</td>
        		    <td width='16%' class='title'>현위치</td>		  		  
                    <td width='20%' class='title'>차량번호</td>		  		  
                    <td width='17%' class='title'>차명</td>
                </tr>
            </table>
    	</td>
    	<td class='line' width='48%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
        		    <td width='12%' class='title'>배기량</td>
        		    <td width='23%' class='title'>연료</td>
        		    <td width='18%' class='title'>최초등록일</td>
        		    <td width='23%' class='title'>칼라</td>		  
        		    <td width='12%' class='title'>경과일</td>		  
        		    <td width='12%' class='title'>가동율</td>        
        		</tr>
    	    </table>
    	</td>
    </tr>
<%	if(cont_size > 0){	%>  
    <tr>
	    <td class='line' width='52%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable reserv = (Hashtable)conts.elementAt(i);%>	
                <tr> 
                  <td width='7%' align='center'><%=i+1%> </td>
                  <td width='7%' align='center'><input type="checkbox" name="pr" value="<%=reserv.get("CAR_MNG_ID")%>"></td>		  
                  <td width='8%' align='center'>
        			  <%if(String.valueOf(reserv.get("PREPARE")).equals("예비")){%>
                      <font color="#999999"><%=reserv.get("PREPARE")%></font> 
                      <%}else{%>
                      <font color="red"><%=reserv.get("PREPARE")%></font> 
                      <%}%>		  
        		  </td>
                  <td width='12%' align='center'><%=reserv.get("BRCH_NM")%></td>		  
                  <td width='13%' align='center'>		  
                      <%if(String.valueOf(reserv.get("CAR_STAT")).equals("예약")){%>
        			  	<span title="[<%=reserv.get("RENT_ST_NM")%>]<%=reserv.get("BUS_NM")%>:<%=reserv.get("FIRM_NM")%> <%=reserv.get("CUST_NM")%> <%=reserv.get("RENT_START_DT")%>">예약</span>
                      <%}else if(String.valueOf(reserv.get("CAR_STAT")).equals("대기")){%>			  
                   	  	<%if(String.valueOf(reserv.get("SITUATION")).equals("")){%>-<%}else{%><span title="[<%=reserv.get("SITUATION_DT")%>]<%=reserv.get("DAMDANG")%>:<%=reserv.get("MEMO")%>"><%=reserv.get("SITUATION")%></span><%}%>
                      <%}else{%>
        	            <%=reserv.get("RENT_ST_NM")%> 
                      <%}%>
        		  </td>		  
                  <td width='16%' align='center'>
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
                  <td width='20%' align='center'>
                    	<a href="javascript:parent.car_reserve('<%=reserv.get("RENT_S_CD")%>', '<%=reserv.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true">
                      	<%if(String.valueOf(reserv.get("A_CNT")).equals("0")){%>
                      	<%=reserv.get("CAR_NO")%>
                      	<%}else{%>			  
                      	<font color="#ff8200"><%=reserv.get("CAR_NO")%></font> 
                      <%}%>			  
        			</a>
        		  </td>
                  <td width='17%' align='center'><span title='<%=reserv.get("CAR_NM")+" "+reserv.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(reserv.get("CAR_NM")+" "+reserv.get("CAR_NAME")), 4)%></span></td>		  
                </tr>
        <%	}%>
            </table>
	    </td>
	    <td class='line' width='48%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable reserv = (Hashtable)conts.elementAt(i);%>			
                <tr>
                    <td width='12%' align="center"><%=reserv.get("DPM")%>cc</td>
                    <td width='23%' align="center"> <%=Util.subData(String.valueOf(reserv.get("FUEL_KD")), 6)%></td>
                    <td width="18%" align='center'><%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
                    <td width='23%' align="center"><%=Util.subData(String.valueOf(reserv.get("COLO")), 8)%></td>
                    <td width="12%" align='center'><%=reserv.get("DAY")%>일</td>						
                    <td width='12%' align="center"><font color="#FF0000">
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
                </tr>
		<%	}%>
	        </table>
	    </td>
<%	}else{	%>                     
    <tr>		
        <td class='line' width='52%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>등록된 데이타가 없습니다</td>
                </tr>
            </table>
    	</td>
    	<td class='line' width='48%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
        		    <td>&nbsp;</td>
        		</tr>
    	    </table>
	    </td>
    </tr>
<%	}	%>
<!--  
  <tr>
	<td class='line'>
	<%if(cont_size > 0){
			for(int i = 0 ; i < cont_size ; i++){
				Hashtable reserv = (Hashtable)conts.elementAt(i);
//				String res_st = String.valueOf(reserv.get("RES_ST"));
//				String use_st = String.valueOf(reserv.get("USE_ST"));
	%>	
	    <table border="0" cellspacing="1" cellpadding="0" width='800'>
          <tr> 
            <td width='30' align='center'><%=i+1%></td>
            <td width='40' align='center'> 
              <input type="checkbox" name="pr" value="<%=reserv.get("CAR_MNG_ID")%>">
            </td>
            <td width='40' align='center'> 
              <%if(String.valueOf(reserv.get("PREPARE")).equals("예비")){%>
              <font color="#999999"><%=reserv.get("PREPARE")%></font> 
              <%}else{%>
              <font color="red"><%=reserv.get("PREPARE")%></font> 
              <%}%>
            </td>

            <td width='90' align='center'>
            	<a href="javascript:parent.car_reserve('<%=reserv.get("RENT_S_CD")%>', '<%=reserv.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true">
              	<%if(String.valueOf(reserv.get("A_CNT")).equals("0")){%>
              	<%=reserv.get("CAR_NO")%>
              	<%}else{%>			  
              	<font color="#ff8200"><%=reserv.get("CAR_NO")%></font> 
              <%}%>			  
			</a></td>

			
            <td width='100'align='center'><span title='<%=reserv.get("CAR_NM")+" "+reserv.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(reserv.get("CAR_NM")+" "+reserv.get("CAR_NAME")), 6)%></span></td>
            <td align='center' width="70"><%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
            <td align='center' width="60"><%=reserv.get("DAY")%>일</td>			
            <td width='70' align="center"><span title='<%=reserv.get("FUEL_KD")%>'><%=Util.subData(String.valueOf(reserv.get("FUEL_KD")), 3)%></span></td>
            <td width='50' align="center"><%=reserv.get("DPM")%></td>
            <td width='60' align="center"><span title='<%=reserv.get("COLO")%>'><%=Util.subData(String.valueOf(reserv.get("COLO")), 3)%></span></td>
            <td width='50' align="center"><font color="#FF0000">
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
            <td align='center' width='40'>
              <font color="#7A4F9D">
              
              <%//if(!String.valueOf(reserv.get("PREPARE")).equals("예비")){%>
              <%//=reserv.get("PREPARE")%>
              <%//}else{%>
              <%=reserv.get("CAR_STAT")%> 
              <%//}%>
              </font></td>
            <td align='center' width='40'> 
              <%if(!String.valueOf(reserv.get("CAR_STAT")).equals("대기")){%>
              <%=reserv.get("RENT_ST_NM")%> 
              <%}else{%>
              - 
              <%}%>
            </td>
            <td align='center' width='60'>
			  <%if(String.valueOf(reserv.get("CAR_STAT")).equals("-") || String.valueOf(reserv.get("CAR_STAT")).equals("대기") || String.valueOf(reserv.get("CAR_STAT")).equals("예약")){%>			  
	              <a class=index1 href="javascript:MM_openBrWindow('car_park.jsp?c_id=<%=reserv.get("CAR_MNG_ID")%>&car_no=<%=reserv.get("CAR_NO")%>','CarPark','scrollbars=no,status=yes,resizable=yes,width=420,height=200,left=50, top=50')">
				  <%if(String.valueOf(reserv.get("PARK")).equals("")){%>
				  등록
				  <%}else{%>
	              <%=reserv.get("PARK")%>			  
			  	  <%}%>
				  </a>			  
              <%}else{%>
			      <font color="#999999">
                  <%if(String.valueOf(reserv.get("RENT_ST_NM")).equals("업무")){%>
				  	<span title='<%=reserv.get("CUST_NM")%>'><%=Util.subData(String.valueOf(reserv.get("CUST_NM")), 3)%></span>				  
                  <%}else{%>
				  	<span title='<%=reserv.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(reserv.get("FIRM_NM")), 3)%></span>
				  <%}%>
				  </font>
              <%}%>
			</td>
          </tr>
        </table>
	<%	}
  		}else{%> 	
	  <table border="0" cellspacing="1" cellpadding="0" width='800'>	                    
        <tr>
 		  <td colspan='13' align='center'>등록된 데이타가 없습니다</td>
		</tr>
	  </table>
	<%}%>	  	
	</td>
  </tr>		
</table>-->
</form>
</body>
</html>
