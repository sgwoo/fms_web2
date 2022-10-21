<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="../../include/index.css">
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

	function ScheDisp(user_id, year, mon, day){
		var theForm = document.thefrm;
		var url = "?user_id=" + user_id
				+ "&start_year=" + year 
				+ "&start_mon=" + mon
				+ "&start_day=" + day;
		var SUBWIN="sch_c.jsp" + url;		
		window.open(SUBWIN, "SchDisp", "left=100, top=100, width=620, height=400, scrollbars=yes");
	}	
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	
//-->
</script>
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"6":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
//	int s_year = request.getParameter("s_year")==null?0:Util.parseDigit(request.getParameter("s_year"));
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"a.car_nm":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");	
	String s_month = request.getParameter("s_month")==null?"":request.getParameter("s_month");
	if(s_year.equals("")) 	s_year = AddUtil.getDate(1);
	if(s_month.equals("")) 	s_month = AddUtil.getDate(2);	
	
	int days = AddUtil.getMonthDate(Integer.parseInt(s_year), Integer.parseInt(request.getParameter("s_month")));
	
	
	
	Vector conts = rs_db.getRentDiaryList(br_id, gubun1, gubun2, brch_id, start_dt, end_dt, car_comp_id, code, s_cc, s_year, s_month, s_kd, t_wd, sort_gubun, asc);
	int cont_size = conts.size();
%>
<table border="0" cellspacing="0" cellpadding="0" width=<%=430+130*days%>>
  <tr id='tr_title' style='position:relative;z-index:1'>	
    <td bgcolor=#000000 width='430' id='td_title' style='position:relative;'>	
      <table border="0" cellspacing="1" cellpadding="0" width='430' height="80">
        <tr align="center" bgcolor="#6784ba"> 
          <td rowspan="4" width="30"><font color="#FFFFFF">연번</font></td>
          <td rowspan="4" width="130"><font color="#FFFFFF">차량사진</font></td>
          <td width='140' bgcolor="#6784ba"><font color="#FFFFFF">차량번호</font></td>
          <td rowspan="4" width="130"><font color="#FFFFFF"><%=AddUtil.getDate(2)%>월 <%=AddUtil.getDate(3)%>일</font></td>		  
        </tr>
        <tr> 
          <td bgcolor="#6784ba" align="center"><font color="#FFFFFF">최초등록일</font></td>
        </tr>
        <tr> 
          <td bgcolor="#6784ba" align="center"><font color="#FFFFFF">차종</font></td>
        </tr>
        <tr> 
          <td bgcolor="#6784ba" align="center"><font color="#FFFFFF">가동율(%)</font></td>
        </tr>
      </table>
	</td>
	<td bgcolor=#000000> 
      <table border="0" cellspacing="1" cellpadding="0" width='<%=130*days%>' height="80">
        <tr> 
          <%for(int j=0; j<days ; j++){%>
          <td rowspan="4" class='title' height="76" width="130" bgcolor="#6784ba" align="center"><font color="#FFFFFF"><%=s_month%>월 
            <%=j+1%>일</font></td>
          <%}%>
        </tr>
      </table>
	</td>
  </tr>		
  <tr>
	<td bgcolor=#000000 width='430' id='td_con' style='position:relative;'>			
	  <table border="0" cellspacing="1" cellpadding="0" width='430' height="<%=100*cont_size%>">
        <%if(cont_size > 0){
			for(int i = 0 ; i < cont_size ; i++){
				Hashtable reserv = (Hashtable)conts.elementAt(i);
				String res_st = String.valueOf(reserv.get("RES_ST"));
				String use_st = String.valueOf(reserv.get("USE_ST"));
	%>
        <tr bgcolor="#FFFFFF"> 
          <td align='center' rowspan="4" width="30"><%=i+1%></td>
          <td align='center' rowspan="4" width="130" height="100"> 
            <%if(String.valueOf(reserv.get("IMGFILE1")).equals("")){%>
            <a href="javascript:parent.car_reserve('<%=reserv.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"> 
            <img name="carImg" src="/acar/off_ls_hpg/img/no_photo.gif" border="0" width="120" height="84"></a> 
            <%}else{%>
            <a class=index1 href="javascript:MM_openBrWindow('/acar/secondhand_hp/bigimg.jsp?c_id=<%=reserv.get("CAR_MNG_ID")%>','popwin0','scrollbars=no,status=no,resizable=yes,width=800,height=600')"> 
            <img name="carImg" src="https://fms3.amazoncar.co.kr/images/carImg/<%=String.valueOf(reserv.get("IMGFILE1"))%>.gif" border="0" width="120" height="84"></a> 
            <%}%>
          </td>
          <td align='center' width="140"><a href="javascript:parent.car_reserve('<%=reserv.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"><font color="#0000FF"><%=reserv.get("CAR_NO")%></font></a></td>
          <td align='center' valign="top" rowspan="4" width="130">
            <table width="100%" border="1" cellspacing="0" cellpadding="0">
              <%//현재일자 운행일지 조회
				Vector scds = rs_db.getResCarScdList(String.valueOf(reserv.get("CAR_MNG_ID")), AddUtil.getDate(4));
				int scd_size = scds.size();
				if(scd_size > 0){
					for(int k = 0 ; k < scd_size ; k++){
						Hashtable scd = (Hashtable)scds.elementAt(k);%>
              <tr> 
                <td rowspan="2" width="30" bgcolor="#FFFF99" align="center"><font color="#990000"><%=scd.get("RENT_ST")%></font></td>
                <td><a href="javascript:parent.view_cont('<%=String.valueOf(scd.get("RENT_S_CD"))%>','<%=String.valueOf(reserv.get("CAR_MNG_ID"))%>');" title="<%=AddUtil.ChangeDate4(String.valueOf(scd.get("DELI_DT")))%>~<%=AddUtil.ChangeDate4(String.valueOf(scd.get("RET_DT")))%>"><%=scd.get("CUST_NM")%></a></td>
              </tr>
              <tr>
                <td><span title='<%=scd.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(scd.get("FIRM_NM")), 6)%></span></td>
              </tr>
              <%	}%>
			  <%	if(scd_size > 2){%>
              <tr align="right"> 
                <td colspan="2">more</td>
              </tr>
			  <%	}%>
              <%}%>
            </table>
          </td>
        </tr>
        <tr> 
          <td align='center' bgcolor="#FFFFFF"><%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
        </tr>
        <tr> 
          <td align='center' bgcolor="#FFFFFF"><span title='<%=reserv.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(reserv.get("CAR_NM")), 10)%></span></td>
        </tr>
        <tr> 
          <td align='center' bgcolor="#FFFFFF">&nbsp;<font color="#FF0000"><%=reserv.get("USE_PER")%>%&nbsp;</font></td>
        </tr>
	<%	}%> 	
	<%}else{%>
        <tr colspan='4'> 
          <td align='center' bgcolor="#FFFFFF">등록된 데이타가 없습니다.</td>
        </tr>	
	<%}%>	
	  </table>	 
	<td bgcolor=#000000> 
      <table border="0" cellspacing="1" cellpadding="0" width='<%=130*days%>'  height="<%=100*cont_size%>">
        <%if(cont_size > 0){
			for(int i = 0 ; i < cont_size ; i++){
				Hashtable reserv = (Hashtable)conts.elementAt(i);
				String res_st = String.valueOf(reserv.get("RES_ST"));
				String use_st = String.valueOf(reserv.get("USE_ST"));
	%>	  
        <tr> 
          <%for(int j=0; j<days ; j++){%>
          <td height="100" valign="top" width="130" bgcolor="#FFFFFF" align="center">
            <table width="100%" border="1" cellspacing="0" cellpadding="0">
              <%//일자별 운행일지 조회
				Vector scds = rs_db.getResCarScdList(String.valueOf(reserv.get("CAR_MNG_ID")), s_year+AddUtil.addZero(s_month)+AddUtil.addZero2(j+1));
				int scd_size = scds.size();
				if(scd_size > 0){
					for(int k = 0 ; k < scd_size ; k++){
						Hashtable scd = (Hashtable)scds.elementAt(k);%>
              <tr> 
                <td rowspan="2" width="30" bgcolor="#FFFF99" align="center"><font color="#990000"><%=scd.get("RENT_ST")%></font></td>
                <td><a href="javascript:parent.view_cont('<%=String.valueOf(scd.get("RENT_S_CD"))%>','<%=String.valueOf(reserv.get("CAR_MNG_ID"))%>');" title="<%=AddUtil.ChangeDate4(String.valueOf(scd.get("DELI_DT")))%>~<%=AddUtil.ChangeDate4(String.valueOf(scd.get("RET_DT")))%>"><%=scd.get("CUST_NM")%></a></td>
              </tr>
              <tr>
                <td><span title='<%=scd.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(scd.get("FIRM_NM")), 6)%></span></td>
              </tr>
              <%	}%>
			  <%	if(scd_size > 2){%>
              <tr align="right"> 
                <td colspan="2">more</td>
              </tr>
			  <%	}%>
              <%}%>
            </table>
          </td>
          <%}%>
        </tr>
	<%	}%> 
	<%}else{%>
        <tr colspan='<%=days%>'> 
          <td align='center' bgcolor="#FFFFFF">등록된 데이타가 없습니다.</td>
        </tr>		
	<%}%>		
      </table>
	</td>
  </tr>		
</table>
</body>
</html>
