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
%>


<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<style type="text/css" media="print">
    @page {
        size:  auto;
        margin: 5mm 0mm 0mm 0mm;
    }
    html {
        background-color: #FFFFFF;
        margin: 0px;
    }
    body {
    	-webkit-print-color-adjust: exact; 
    	-ms-print-color-adjust: exact; 
    	color-adjust: exact;
    	transform: scale(.9);    	
        /* margin으로 프린트 여백 조정 */
        /* IE */
        margin: 0mm 0mm 0mm 0mm;
        
        /* CHROME */
        -webkit-margin-before: 0mm; /*상단*/
		-webkit-margin-end: 0mm; /*우측*/
		-webkit-margin-after: 0mm; /*하단*/
		-webkit-margin-start: 0mm; /*좌측*/
    }
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script>

	
	function pagesetPrint(){
		IEPageSetupX.header='';
		IEPageSetupX.footer='';
		IEPageSetupX.leftMargin=5;
		IEPageSetupX.rightMargin=5;
		IEPageSetupX.topMargin=20;
		IEPageSetupX.bottomMargin=20;		
		print(); 
	}
	
	function ieprint() {
		factory.printing.header 	= ""; //폐이지상단 인쇄
		factory.printing.footer 	= ""; //폐이지하단 인쇄
		factory.printing.portrait 	= false; //true-세로인쇄, false-가로인쇄    
		factory.printing.leftMargin 	= 10.0; //좌측여백   
		factory.printing.rightMargin 	= 10.0; //우측여백
		factory.printing.topMargin 	= 5.0; //상단여백    
		factory.printing.bottomMargin 	= 5.0; //하단여백
		factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
	}
	
	function onprint() {
		var userAgent=navigator.userAgent.toLowerCase();
		
		if (userAgent.indexOf("edge") > -1) {
			window.print();
		} else if (userAgent.indexOf("whale") > -1) {
			window.print();
		} else if (userAgent.indexOf("chrome") > -1) {
			window.print();
		} else if (userAgent.indexOf("firefox") > -1) {
			window.print();
		} else if (userAgent.indexOf("safari") > -1) {
			window.print();
		} else {
			ieprint();
		}
	}

</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<form name='form1' action='park_wa_sc.jsp' method='post' target='c_foot'>
    <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td>
	    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>금일(명일) 작업지시 현황</span>
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
                    <td width='2%' rowspan='2' class='title'>연번</td>
                    <td width='15%' colspan="3" class='title'>작업대상</td>
                    <td width='15%' colspan="2" class='title'>작업일정</td>
                    <td width='6%' colspan="2" class='title'>작업요청건</td>
                    <td width='10%' colspan="2" class='title'>진행상황</td>
                    <td width='10%' colspan="2" class='title'>관리담당자</td>
                    <td width='10%' colspan="2" class='title'>등록정보</td>
                </tr>
                <tr>
                	<td class='title'>차량번호</td>
                	<td class='title'>차 명</td>
                	<td class='title'>주차위치</td>
                	<td class='title'>등록일자</td>
                	<td class='title'>작업요청일자</td>
                	<td class='title'>세차</td>
                	<td class='title'>실내</td>
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
               				<a href="javascript:sendMsg(<%=i%>,<%=ht.get("SEQ")%>);"><img src=/acar/images/center/button_in_conf.gif align=absmiddle border=0"></a>	
                		<%	}%>
                	
                	</td>
                	
                	<td align="center"><%if(!ht.get("F_WASH_END").equals("")){%><%=ht.get("F_WASH_END")%><%} %></td>
                	<td align="center"><%=ht.get("USERS_COMP")%></td>
                	<td align="center"><%=ht.get("USER_M_TEL")%></td>
                	<%if(!String.valueOf(ht.get("WASH_ETC")).equals("")){ %>
	                	<td align="center"><%=ht.get("WASH_ETC")%></td>
                	<%}else{%>
                		<td align="center">작업지시건</td>
                	<%}%>
                	<td align="center"><%=ht.get("USER_NM")%></td>
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
