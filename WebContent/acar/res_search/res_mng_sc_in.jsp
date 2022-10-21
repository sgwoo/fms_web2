<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="../../include/table.css">
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
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":AddUtil.ChangeString(request.getParameter("start_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	int s_year = request.getParameter("s_year")==null?0:Util.parseDigit(request.getParameter("s_year"));
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"a.car_nm":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	Vector conts = rs_db.getResStatList(br_id, gubun1, gubun2, brch_id, start_dt, end_dt, car_comp_id, code, s_cc, s_year, s_kd, t_wd, sort_gubun, asc);
	int cont_size = conts.size();
%>
<table border="0" cellspacing="0" cellpadding="0" width=920>
  <tr id='tr_title' style='position:relative;z-index:1'>		
    <td class='line' width='480' id='td_title' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='480'>
        <tr> 
          <td width='30' class='title'>연번</td>
          <td width='60' class='title'>배차</td>
          <td width='60' class='title'>취소</td>
          <td width='50' class='title'>지점</td>
          <td width='80' class='title'>계약구분</td>
          <td width='100' class='title'>상호/성명</td>
          <td width='100' class='title'>차량번호</td>
        </tr>
      </table>
	</td>
	<td class='line' width='440'>
	  <table border="0" cellspacing="1" cellpadding="0" width='440'>
		<tr>
          <td width='100' class='title'>차명</td>
		  <td width='80' class='title'>대여개시일</td>
		  <td width='80' class='title'>대여만료일</td>
		  <td width='120' class='title'>배차예정일시</td>
		  <td width='60' class='title'>담당자</td>
		</tr>
	  </table>
	</td>
  </tr>
<%	if(cont_size > 0){	%>  
  <tr>
	<td class='line' width='480' id='td_con' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='480'>
		<%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable reserv = (Hashtable)conts.elementAt(i);%>	
        <tr> 
          <td width='30' align='center'><%=i+1%></td>		  
          <td width='60' align='center'>
			<%if(!String.valueOf(reserv.get("RENT_ST")).equals("예약대기")){%>
            <input type="button" name="Y" value="배차" onClick="javascript:parent.reserve_action('Y', '<%=reserv.get("RENT_S_CD")%>', '<%=reserv.get("CAR_MNG_ID")%>');">
			<%}%>
          </td>
          <td width='60' align='center'>
            <input type="button" name="N" value="취소" onClick="javascript:parent.reserve_action('N', '<%=reserv.get("RENT_S_CD")%>', '<%=reserv.get("CAR_MNG_ID")%>');">		  
		  </td>		  
          <td width='50' align='center'><%=reserv.get("BRCH_ID")%></td>		
          <td width='80' align='center'><font color="Maroon"><%=reserv.get("RENT_ST_NM")%></font></td>				
          <td width='100' align='center'><font color="#808080"><span title='<%=reserv.get("CUST_NM")%>'><%=AddUtil.subData(String.valueOf(reserv.get("CUST_NM")), 6)%></span></font></td>		    
          <td width='100' align='center'><a href="javascript:parent.view_car('<%//=reserv.get("RENT_S_CD")%>', '<%=reserv.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"><%=reserv.get("CAR_NO")%></a></td>
        </tr>
        <%	}%>
      </table>
	</td>
	<td class='line' width='440'>
	  <table border="0" cellspacing="1" cellpadding="0" width='440'>
		<%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable reserv = (Hashtable)conts.elementAt(i);%>			
        <tr>
          <td width='100'>&nbsp;<span title='<%=reserv.get("CAR_NM")+" "+reserv.get("CAR_NAME")%>'><%=AddUtil.subData(String.valueOf(reserv.get("CAR_NM"))+" "+String.valueOf(reserv.get("CAR_NAME")), 6)%></span></td>		
          <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(reserv.get("RENT_START_DT")))%></td>
          <td width='70'align='center'><%=AddUtil.ChangeDate2(String.valueOf(reserv.get("RENT_END_DT")))%></td>
          <td width='110' align='center'><font color="#9F3580"><%=AddUtil.ChangeDate3(String.valueOf(reserv.get("DELI_PLAN_DT")))%></font></td>
          <td width='110' align="center"><%=reserv.get("BUS_ID")%></td>
        </tr>
		<%	}%>
	  </table>
	</td>
<%	}else{	%>                     
  <tr>		
    <td class='line' width='480' id='td_con' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='480'>
        <tr> 
          <td align='center'>등록된 데이타가 없습니다</td>
        </tr>
      </table>
	</td>
	<td class='line' width='440'>			
      <table border="0" cellspacing="1" cellpadding="0" width='440'>
        <tr>
		  <td>&nbsp;</td>
		</tr>
		  </table>
		</td>
	</tr>
<%	}	%>
</table>
</body>
</html>
