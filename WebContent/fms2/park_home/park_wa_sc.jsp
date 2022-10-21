<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.parking.*, java.*, java.text.SimpleDateFormat"%>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
		
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String park_id = request.getParameter("park_id")==null?"1":request.getParameter("park_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String values = "?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&brid="+brid+
			"&gubun1="+gubun1+"&gubun2="+gubun2+"&start_dt="+start_dt+"&end_dt="+end_dt+
			"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort="+sort+
		   	"&sh_height="+sh_height;
	
	Vector vt = pk_db.getParkWashDayList(park_id, gubun1, gubun2, car_no, start_dt, end_dt, off_id);
	int vt_size = vt.size();
	
	Date today = new Date();	        
	SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat time = new SimpleDateFormat("hh:mm");

	String year = date.format(today);
	String ms = time.format(today);
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script>
	function ParkWashReg() {
		var SUBWIN="park_w_i.jsp";
		window.open(SUBWIN, "ParkInReg", "left=10, top=20, width=1200, height=220, scrollbars=no");
	}
	
	function print() {
		var SUBWIN="park_w_print.jsp";
		window.open(SUBWIN, "ParkInPrint", "left=10, top=20, width=1500, height=800, scrollbars=no");
	}
	
	function sendMsg(i, park_seq){
		if(!document.getElementById("wash_pay"+i).checked && !document.getElementById("inclean_pay"+i).checked){
			alert("작업요청건 중 1개는 선택하셔야 합니다. ")
			return false;
		}
		
		var car_no = document.getElementById("car_no"+i).innerHTML ;
		
		var wash_etc ="";
		if(document.getElementById("wash_etc"+i) !=null ){
			var wash_etc = document.getElementById("wash_etc"+i).innerHTML ;
			
		}
		var reg_id = document.getElementById("reg_id"+i).value ;
		var wash_pay = '';
		if(document.getElementById("wash_pay"+i).checked){
			wash_pay = '0';
		 }
		
		var inclean_pay = '';
		if(document.getElementById("inclean_pay"+i).checked){
			inclean_pay = '0';
		 }
		
		var gubun_st= '0';
		
		var SUBWIN="park_wa_sc_a.jsp?wash_pay="+wash_pay+"&inclean_pay="+inclean_pay+"&car_no="+car_no+"&park_seq="+park_seq+"&gubun_st="+gubun_st+"&wash_etc="+wash_etc+"&reg_id="+reg_id;
		window.open(SUBWIN, "", "left=10, top=20, width=500, height=200, scrollbars=no");
	}
	
	
</script>



</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='park_wa_sc.jsp' method='post' target='c_foot'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td>
	    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>금일(명일) 작업지시 현황</span>
	    	<!-- <a href="javascript:ParkWashReg();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0 style="margin-left: 20px;"></a>	    	 -->
	    	<a href="javascript:print();"><img src=/acar/images/center/button_print.gif align=absmiddle border=0 style="margin-left: 20px;"></a>
	    </td>
	</tr>
	<tr>
		<td align="right">
			<span id=""><%=year%>, <%=ms%></span> 현재&nbsp;
		</td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class="line" >
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td rowspan='2' class='title'>연번</td>
                    <td colspan="3" class='title'>작업대상</td>
                    <td colspan="2" class='title'>작업일정</td>
                    <td colspan="2" class='title'>작업요청건</td>
                    <td colspan="2" class='title'>진행상황</td>
                    <td colspan="2" class='title'>관리담당자</td>
                    <td colspan="2" class='title'>등록정보</td>
                </tr>
                <tr>
                	<td class='title'>차량번호</td>
                	<td class='title'>차 명</td>
                	<td class='title'>주차위치</td>
                	<td class='title'>등록일자</td>
                	<td class='title'>작업요청일자</td>
                	<td class='title'>세차</td>
                	<td class='title'>크리닝<br>&냄새</td>
                	<td class='title'>구분</td>
                	<td class='title'>완료시각</td>
                	<td class='title'>이름</td>
                	<td class='title'>연락처</td>
                	<td class='title'>등록여부</td>
                	<td class='title'>등록자</td>
                </tr>
                <% 
				    if( vt_size > 0) {
						for(int i = 0 ; i < vt_size ; i++) {
							Hashtable ht = (Hashtable)vt.elementAt(i);
				%>
				<tr>
                	<td align="center"><%=i+1%></td>
                	<td align="center" id="car_no<%=i%>"><%=ht.get("CAR_NO")%></td>
                	<td align="center"><%=ht.get("CAR_NM")%></td>
                	<td align="center">
                		<%=ht.get("PARK_NM")%>
                		<% if (!ht.get("AREA").equals("")) { %>
                			&nbsp;<font style="color: blue; font-weight: bold;"><%=ht.get("AREA")%></font>
                		<% } %>
                	</td>
                	<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
                	<td align="center"><%=ht.get("F_REQ_DT")%></td>
                	<td align="center">
                		<input type="checkbox" name="wash_pay" id="wash_pay<%=i%>"
                		 <%if(!ht.get("WASH_PAY").equals("")){%>checked<%}%> <%if(!String.valueOf(ht.get("GUBUN_ST2")).equals("")){%>onclick="return false;<%}%>">
                	</td>
                	<td align="center"><input type="checkbox" name="inclean_pay" id="inclean_pay<%=i%>"
                		<%if(!ht.get("INCLEAN_PAY").equals("")){%>checked<%}%> <%if(!String.valueOf(ht.get("GUBUN_ST2")).equals("")){%>onclick="return false;<%}%>">
                	
                	</td>
                	<td align="center">
                		<%	if(!String.valueOf(ht.get("GUBUN_ST2")).equals("")){%>
                			<%=ht.get("GUBUN_ST2")%>
                		<%}else{%>
                			<%	if(nm_db.getWorkAuthUser("본사주차장",user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
               				<a href="javascript:sendMsg(<%=i%>,<%=ht.get("SEQ")%>);"><img src=/acar/images/center/button_in_conf.gif align=absmiddle border=0"></a>	
               				<%}else{ %>
               				보류
               				<%} %>
                		<%	}%>
                	
                	</td>
                	
                	<td align="center"><%if(!ht.get("F_WASH_END").equals("")){%><%=ht.get("F_WASH_END")%><%} %></td>
                	<td align="center"><%=ht.get("USERS_COMP")%></td>
                	<td align="center"><%=ht.get("USER_M_TEL")%></td>
                	<%if(!String.valueOf(ht.get("WASH_ETC")).equals("")){ %>
	                	<td align="center" id="wash_etc<%=i%>"  width="25%" style="word-break:break-all;padding:0px 10px;"><%=ht.get("WASH_ETC")%></td>
                	<%}else{%>
                		<td align="center">작업지시건</td>
                	<%}%>
                	<td align="center"><%=ht.get("USER_NM")%></td>
                	<input type='hidden' id='reg_id<%=i%>' value='<%=ht.get("REG_ID")%>'>
                </tr>
				<%  }
  					} else { %>
				<tr height="40">
					<td colspan="14" align="center">데이터가 없습니다.</td>
				</tr>
			 	<% 
			 		} %>
             </table>
		</td>
	</tr>         
  </table>
</form>
</body>
</html>
