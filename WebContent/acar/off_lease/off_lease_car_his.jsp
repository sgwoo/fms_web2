<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.offls_yb.*, acar.util.*, acar.res_search.*"%>
<jsp:useBean id="olyD" scope="page" class="acar.offls_yb.Offls_ybDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int count =0;
	
	Vector his = olyD.getCarHisList(car_mng_id);
	int his_size = his.size();
	
	//자산양수차량
	Hashtable ht_ac = shDb.getCarAcInfo(car_mng_id);
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
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
	
	function pop_excel(){
		var fm = document.form1;
		fm.target = "_blak";
		fm.action = "off_lease_car_his_excel.jsp";
		fm.submit();
	}		
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form name="form1" method="post">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="from_page" value="<%=from_page%>">
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
  <tr> 
    <td>
      <table width=100% border=0 cellpadding=0 cellspacing=0>
        <tr>
          <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
          <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>차량이력</span></span></td>
          <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
        </tr>
      </table>            
    </td>
  </tr>
  <tr>
    <td class=h></td>
  </tr>
	<tr> 
	  <td align="right"><a href="javascript:pop_excel();"><img src=../images/center/button_excel.gif border=0 align=absmiddle></a></td>
	</tr>
	<tr>
	  <td class=line2 colspan=2></td>
	</tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
    <td colspan=2 class='line' width='100%' id='td_title' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr> 
          <td width=5% class='title'>연번</td>
          <td width=47% class='title'>상호</td>
          <td width=15% class='title'>계약자</td>
          <td width=18% class='title'>이용기간</td>
          <td width=15% class='title'>해지사유</td>
        </tr>
      </table>
    </td>
	</tr>
  <%if(his_size > 0){%>
	<tr>
    <td class='line' width='100%' id='td_con' style='position:relative;' colspan=2>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
	      <%if(!String.valueOf(ht_ac.get("CAR_MNG_ID")).equals("") && !String.valueOf(ht_ac.get("CAR_MNG_ID")).equals("null")){
	      		count++;
	      %>
        <tr>
          <td width=5% align='center'><%=count%></td>
          <td width=47% align='left'>&nbsp;&nbsp;<%=ht_ac.get("CAR_OFF_NM")%></td>
          <td width=15% align='center'>*****</td>
          <td width=18% align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht_ac.get("SH_INIT_REG_DT")))%> ~ <%=AddUtil.ChangeDate2(String.valueOf(ht_ac.get("SH_BASE_DT")))%></td>
        	<td width=15% align='center'>자산양수</td>
        </tr>
	      <%}%>
        <%for(int i = 0 ; i < his_size ; i++){
    				CarHisBean ch = (CarHisBean)his.elementAt(i);
    				count++;
    		%>
        <tr>
          <td width=5% align='center'><%=count%></td>
          <td width=47% align='left'><span title='<%=ch.getFirm_nm()%>'>&nbsp;&nbsp;<%=AddUtil.subData(ch.getFirm_nm(), 15)%></span></td>
          <td width=15% align='center'><span title='<%=ch.getClient_nm()%>'><%=AddUtil.subData(ch.getClient_nm(), 4)%></span></td>
          <td width=18% align='center'><%=AddUtil.ChangeDate2(ch.getRent_st_dt())%> ~ <%=AddUtil.ChangeDate2(ch.getRent_ed_dt())%></td>
        	<td width=15% align='center'>
        		<%if(ch.getCls_st().equals("1")){%>계약만료
        		<% }else if(ch.getCls_st().equals("2")){ %>중도해약
        		<% }else if(ch.getCls_st().equals("3")){ %>영업소변경
        		<% }else if(ch.getCls_st().equals("4")){ %>차종변경
        		<% }else if(ch.getCls_st().equals("5")){ %>계약이관
        		<% }else if(ch.getCls_st().equals("6")){ %>매각
        		<% }else if(ch.getCls_st().equals("7")){ %>출고전해지
        		<% }else{ %> -
        		<% } %>
        	</td>
        </tr>
        <%}%>
      </table>
    </td>
  </tr> 
  <%}else{%>
  <tr>
    <td class='line' width='100%' id='td_con' style='position:relative;' colspan=2>
	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
	      <%if(!String.valueOf(ht_ac.get("CAR_MNG_ID")).equals("") && !String.valueOf(ht_ac.get("CAR_MNG_ID")).equals("null")){
	      		count++;
	      %>
        <tr>
          <td width=5% align='center'><%=count%></td>
          <td width=47% align='left'>&nbsp;&nbsp;<%=ht_ac.get("CAR_OFF_NM")%></td>
          <td width=15% align='center'>*****</td>
          <td width=18% align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht_ac.get("SH_INIT_REG_DT")))%> ~ <%=AddUtil.ChangeDate2(String.valueOf(ht_ac.get("SH_BASE_DT")))%></td>
        	<td width=15% align='center'>자산양수</td>
        </tr>
	      <%}else{%>
        <tr>
          <td align='center'>등록된 데이타가 없습니다</td>
        </tr>
        <%}%>
      </table>
    </td>
	</tr>
  <%}%>

  <%if(from_page.equals("/acar/fine_mng/fine_mng_sh.jsp")){
	
			//차량정보
			Hashtable res = rs_db.getCarInfo(car_mng_id);
		
			//예약현황
			Vector conts = rs_db.getResCarCauCarList(car_mng_id);
			int cont_size = conts.size();
	%>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보유차 운행이력</span></td>
  </tr>
  <tr>
    <td class=line2></td>
  </tr>
  <tr>
    <td class=line>
      <table border="0" cellspacing="1" cellpadding="0" width=100%>
        <tr>
          <td class=title rowspan='2' width="4%">연번</td>
          <td class=title rowspan='2' width="7%">구분</td>
          <td class=title rowspan='2' width="4%">상태</td>
          <td class=title colspan='2'>자동차</td>
          <td class=title rowspan='2' width="35%">대여기간</td>
          <td class=title rowspan='2' width="30%">상호/성명</td>
        </tr>
				<tr>
          <td class=title width="10%">보유차</td>
          <td class=title width="10%">사유발생</td>
				</tr>
        <%if(cont_size > 0){
    				for(int i = 0 ; i < cont_size ; i++){
    					Hashtable reservs = (Hashtable)conts.elementAt(i);
    		%>
        <tr>
          <td align="center"><%=i+1%></td>
          <td align="center"><%=reservs.get("RENT_ST")%></td>
          <td align="center"><%=reservs.get("USE_ST")%></td>
          <td align="center"><%if(String.valueOf(res.get("CAR_NO")).equals(String.valueOf(reservs.get("CAR_NO")))){%><font color=red><%}%><%=reservs.get("CAR_NO")%><%if(String.valueOf(res.get("CAR_NO")).equals(String.valueOf(reservs.get("CAR_NO")))){%></font><%}%></td>
          <td align="center"><%if(String.valueOf(res.get("CAR_NO")).equals(String.valueOf(reservs.get("D_CAR_NO")))){%><font color=red><%}%><%=reservs.get("D_CAR_NO")%><%if(String.valueOf(res.get("CAR_NO")).equals(String.valueOf(reservs.get("D_CAR_NO")))){%></font><%}%></td>
          <td align="center"><%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_START_DT")))%>시 ~ <%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_END_DT")))%>시</td>
          <td align="center"><%=reservs.get("FIRM_NM")%> <%=reservs.get("CUST_NM")%></td>
        </tr>
        <%	}
      		}else{
      	%>
        <tr>
          <td colspan='7' align='center'>등록된 데이타가 없습니다</td>
        </tr>
        <%}%>
      </table>
    </td>
  </tr>
  <%}%>
</table>
</form>
</body>
</html>