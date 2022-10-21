<%@page import="org.apache.poi.util.StringUtil"%>
<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,java.text.*, acar.util.*, acar.user_mng.*, card.*, acar.parking.*"%>
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
	
	String park_id = request.getParameter("park_id")==null?"":request.getParameter("park_id");	
	String gubun = request.getParameter("gubun")==null?"2":request.getParameter("gubun");
	String gubun1 = request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String values = "?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&brid="+brid+
			"&gubun1="+gubun1+"&gubun2="+gubun2+"&start_dt="+start_dt+"&end_dt="+end_dt+
			"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort="+sort+
		   	"&sh_height="+sh_height;
		
	Vector vt = pk_db.getParkWashDayList(park_id, gubun1, gubun2, car_no, start_dt, end_dt, off_id);
	int vt_size = vt.size();
	
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
	function search() {
		var fm = document.form1;
		fm.action = 'park_wd_sc.jsp';
		fm.target = 'c_foot';
		fm.submit();
	}
	
	//등록
	function ParkWashReg() {
		var SUBWIN="park_w_i2.jsp";
		window.open(SUBWIN, "ParkInReg", "left=10, top=20, width=1200, height=200, scrollbars=no");
	}
	
	//삭제
	function ParkWashDel(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck = fm.elements[i];
			if(ck.name == 'req_check'){
				if(ck.checked == true){
					cnt++;
					idnum = ck.value;
				}
			}
		}
		
		if(cnt == 0){ 
			alert("선택된 데이터가 없습니다.");
			return; 
		}
		
		if(!confirm('삭제하시겠습니까?')){
			return;
		}
		
		fm.del.value="del";
		fm.gubun
		fm.target="i_no";
		fm.action = "park_w_i_a.jsp";
		fm.submit(); 
		

	}
	
	function sendMsg(i, park_seq){
		var	car_no = "";
		var	wash_start = "";
		var	wash_end = "";
	
		car_no = document.getElementById("car_no"+i).innerHTML ;
		reg_id = document.getElementById("reg_id"+i).value ;
		wash_etc = document.getElementById("wash_etc"+i).innerHTML ;
		wash_etc = wash_etc.trim();
		
		var wash_end_check = document.getElementById("wash_end"+i);
		
		if(wash_end_check  && typeof wash_end_check.innerHTML != null){
			
			var wash_pay = '';
			if(document.getElementById("wash_pay"+i).checked){
				wash_pay = '10000';
				wash_start = document.getElementById("wash_start"+i).innerHTML ;
				wash_end = document.getElementById("wash_end"+i).innerHTML ;
			 }
			
			var inclean_pay = '';
			if(document.getElementById("inclean_pay"+i).checked){
				inclean_pay = '20000';
				wash_start = document.getElementById("wash_start"+i).innerHTML ;
				wash_end = document.getElementById("wash_end"+i).innerHTML ;
			 }
			var gubun_st='2';
			var SUBWIN="park_wd_sc_a.jsp?wash_pay="+wash_pay+"&inclean_pay="+inclean_pay+"&car_no="+car_no+"&park_seq="+park_seq+"&gubun_st="+gubun_st+"&wash_start="+wash_start+"&wash_end="+wash_end+"&reg_id="+reg_id+"&wash_etc="+wash_etc;
		 	window.open(SUBWIN, "", "left=10, top=20, width=500, height=200, scrollbars=no"); 
		}else{
			
			alert("종료일이 아직 입력되지 않았습니다\n종료일이 입력되지 않으면 완료로 처리 할 수 없습니다");
			return			
		}		
		
	
	}
</script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script type="text/javascript">
$('document').ready(function() {
	//div값 화면 셋팅값으로 초기화
	var frame_height = Number($("#height").val());
	var search_height = Number($("#search_height").height());
	$("#screen_height").css("height", (frame_height - search_height) - 130);
});

</script>
<style>
	.wash_icon{
		border-radius: 40px;
		background-color:#dd514c;
		display: inline-block;
		padding: 0.25em 0.3em;
		font-size: 0.5pt;
		font-weight: 600;
		color: #fff;
		line-height: 1;
		vertical-align: baseline;
	}
</style>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='park_wd_sc.jsp' method='post' target='c_foot'>
<input type="hidden" name="del" value="">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="height" id="height" value="<%=height%>">

<table id="search_height" border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>일일작업현황</span></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=1>
                <tr> 
                    <td>
                    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gjij.gif align=absmiddle>
						<select name="park_id" id="park_id" >
							<% if (park_id.equals("")) { %>
								<option value="1" <%if(br_id.equals("S1")){%>selected<%}%>>영남주차장</option>
								<%-- <option value="17" <%if(br_id.equals("B1")){%>selected<%}%>>웰메이드</option>
								<option value="7" >부산부경</option>
								<option value="4" <%if(br_id.equals("D1")){%>selected<%}%>>대전지점</option>
								<option value="12" <%if(br_id.equals("J1")){%>selected<%}%>>광주지점</option>
								<option value="13" <%if(br_id.equals("G1")){%>selected<%}%>>대구지점</option> --%>
							<% } else { %>
								<option value="1" <%if(park_id.equals("1")){%>selected<%}%>>영남주차장</option>
								<%-- <option value="17" <%if(park_id.equals("17")){%>selected<%}%>>웰메이드</option>
								<option value="7" <%if(park_id.equals("7")){%>selected<%}%>>부산부경</option>
								<option value="4" <%if(park_id.equals("4")){%>selected<%}%>>대전지점</option>
								<option value="12" <%if(park_id.equals("12")){%>selected<%}%>>광주지점</option>
								<option value="13" <%if(park_id.equals("13")){%>selected<%}%>>대구지점</option> --%>							
							<% } %>						
						</select>
					</td>					
					<td>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		            	<select name='gubun1'>
	                        <option value='1' <%if(gubun1.equals("1")){%>selected<%}%>>당일</option>
	                        <option value='2' <%if(gubun1.equals("2")){%>selected<%}%>>전일</option>
	                        <option value="3" <%if(gubun1.equals("3")){%>selected<%}%>>당월</option>
	                        <option value="4" <%if(gubun1.equals("4")){%>selected<%}%>>전월</option>
	                        <option value="5" <%if(gubun1.equals("5")){%>selected<%}%>>기간</option>
                        </select>
            			<input type='text' size='11' name='start_dt' class='text' value="<%=start_dt%>" onBlur='javscript:this.value = ChangeDate(this.value);' style="width: 100px;">
                                ~ 
                        <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>" onBlur='javscript:this.value = ChangeDate(this.value);' style="width: 100px;">            			      
					</td>
					<td>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<select name='gubun2'>
	                        <option value='1' selected>차량번호 및 차대번호</option>
                        </select>
                        <input type="text" name="car_no" value="<%=car_no%>">
                        &nbsp;<a href="javascript:search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
					</td>
                </tr>                
            </table>
        </td>
    </tr>	
    <tr>
		<td style="text-align: right;">
			<%	if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사주차장",user_id)){%>
				<a href="javascript:ParkWashReg();"><img src=/acar/images/center/newcar_wash_button_reg.png align=absmiddle border=0 style="padding-bottom: 3px;"></a>
			&nbsp;&nbsp;
				<a href="javascript:ParkWashDel();"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0 style="padding-bottom: 3px;"></a>
			<%}%>
		</td>
	</tr> 
    <tr>
		<td class=line2></td>
	</tr>
</table>
<div id="screen_height" style="overflow-y: scroll;">

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                	<td class='title' rowspan="2">선택</td>
                    <td class='title' rowspan="2">연번</td>
                    <td class='title' colspan="2">차랑구분</td>
                    <td class='title' colspan="3">작업완료현황</td>
                    <td class='title' colspan="3">작업내용</td>
                    <td class='title' colspan="5">작업자</td>
                </tr>
                <tr>
                    <td class='title'>차량번호 및<br>차대번호</td>
                    <td class='title'>차명</td>
                    <td class='title'>세차</td>
                    <td class='title'>크리닝<br>&냄새</td>
                    <td class='title'>구분</td>
                    <td class='title'>요청일</td>
                    <td class='title'>시작</td>
                    <td class='title'>종료</td>
                    <td class='title'>작업시간</td>
                    <td class='title'>처리자</td>
                    <td class='title'>작업지시자</td>
                    <td class='title'>작업구분</td>
                    <td class='title'>사유</td>
                </tr>
                <% 
				    if( vt_size > 0) {				    	
						for(int i = 0 ; i < vt_size ; i++) {
							Hashtable ht = (Hashtable)vt.elementAt(i);
							String car_no2 = String.valueOf(ht.get("CAR_NO"));
							
							/* Vector vt2 = pk_db.getParkRealList("1", "", "", "", "",  "",  0,  "1", "1", car_no2 , "", "");
					    	int vt2_size = vt2.size();
							System.out.println(vt2_size); */
							
							/* Hashtable ht2 = (Hashtable)vt2.elementAt(i); */
				%>
                <tr>
                	<td align="center">
                		<% if(String.valueOf(ht.get("GUBUN_ST2")).equals("대기") || String.valueOf(ht.get("GUBUN_ST2")).equals("")){ %>
	                		<input type="checkbox" name="req_check" value="<%=ht.get("SEQ")%>/<%=ht.get("WASH_PAY")%>/<%=ht.get("INCLEAN_PAY")%>/<%=ht.get("CAR_NO")%>/<%=ht.get("GUBUN_ST2")%>"> 
                		<%} %>
                	</td>
                    <td align="center"><%=i+1%></td>
                	<td align="center">
               			<div style="display:inline;">
               				<%-- <%if(ht.get("WASH_PAY") != ""){%><span class="wash_icon" style="background-color:royalblue;">W</span><%} %> --%>
               		<%-- 		<%if(ht.get("INCLEAN_PAY") != ""){%><span class="wash_icon">IN</span><%} %> --%>
               			</div>
               			<div style="display:inline" id="car_no<%=i%>">
	                		<%=ht.get("CAR_NO")%>
               			</div>
                	</td>
                    <td align="center"><%=ht.get("CAR_NM")%></td>
                    	<td align="center">
                		<input type="checkbox" name="wash_pay" id="wash_pay<%=i%>"
                		 <%if(!ht.get("WASH_PAY").equals("")){%>checked<%}%>  <%if(ht.get("WASH_PAY").equals("")){%>onclick="return false;"<%}%>>
                	</td>
                	<td align="center"><input type="checkbox" name="inclean_pay" id="inclean_pay<%=i%>"
                		<%if(!ht.get("INCLEAN_PAY").equals("")){%>checked<%}%> <%if(ht.get("INCLEAN_PAY").equals("")){%>onclick="return false;"<%}%>>
                	
                	</td>
                	<td align="center">
                		<%	if((String.valueOf(ht.get("GUBUN_ST2")).equals("진행")|| String.valueOf(ht.get("GUBUN_ST2")).equals("대기")) 
                					&& !ht.get("INCLEAN_PAY").equals("") ){%>                			
                			<%	if(nm_db.getWorkAuthUser("본사주차장",user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
	               				<a href="javascript:sendMsg(<%=i%>,<%=ht.get("SEQ")%>);"><img src=/acar/images/center/button_in_conf.gif align=absmiddle border=0"></a>	
                			<%}else{%> 
                				확인<br>보류
                			<%}%>
                		<%}else{%>
                				<%if(!String.valueOf(ht.get("GUBUN_ST2")).equals("")){%>	
                					<%=ht.get("GUBUN_ST2")%>
                				<%}else{%>
								      보류
                				<%	}%>
                		<%	}%>
                	
                	</td>
                	 <td align="center">
                	 	<%=ht.get("F_REQ_DT")%>
                	 </td>
                    <td align="center">
                    	<% if (ht.get("F_WASH_START").equals("")) { %>
                    		<% if (ht.get("GUBUN_ST").equals("2")) { %>
                    		<%-- 		<span id="wash_start<%=i%>"><%=ht.get("WASH_START2")%></span> --%>
                    		<% } %>
                    	<% } else { %>
                    		<span id="wash_start<%=i%>"><%=ht.get("F_WASH_START")%></span>
                    	<% } %>
                    </td>
                    
                    <td align="center">
                    	<% if (ht.get("F_WASH_END").equals("")) { %>
                    		<% if (ht.get("GUBUN_ST").equals("2")) { %>
                    			<%-- 	<span id="wash_end<%=i%>"><%=ht.get("WASH_END2")%></span> --%>
                    		<% } %>
                    	<% } else { %>
                    		<span id="wash_end<%=i%>"><%=ht.get("F_WASH_END")%></span>
                    	<% } %>
                    </td>
                    <%
                    	//시간 차이 구하기
                    	String gapTime = "00:00";
                    	String hour="";
                    	String min="";
	                    String wash_start =  String.valueOf(ht.get("F_WASH_START"));
	                	String wash_end =  String.valueOf(ht.get("F_WASH_END"));
                    	if(!wash_start.equals("") && !wash_end.equals("")){
	                    	SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	                    	
	                    	Date start = f.parse(wash_start);
	                    	Date end = f.parse(wash_end);
	                    	
	                    	long gap  = Math.abs(end.getTime() - start.getTime()) /1000;
							long hourGap = gap/60/60 ;
							long reminder = (long)(gap/60)%60;
							long minuteGap = reminder;
							
							if(hourGap >99){
								hourGap = (long)99;
							}
							
							if(hourGap<10){
								hour = "0"+Long.toString(hourGap);
							}else{
								hour =Long.toString(hourGap);
							}
							if(minuteGap<10){
								min ="0"+Long.toString(minuteGap);
							}else{
								min =Long.toString(minuteGap);
							}
							gapTime = hour + ":"+min  ;
                    	}
                    	
                    
                    %>
                    
                    <td align="center"><%=gapTime%></td>
                    <td align="center"><%=ht.get("WASH_USER_NM")%></td>
                    <td align="center"><%=ht.get("USER_NM")%></td>
                    <td align="center">
                   		<% if (ht.get("WASH_ETC").equals("")) { %>
                    				작업지시건
                    	<% } else if (ht.get("WASH_ETC").equals("포괄지시건")) { %>
                    				포괄지시건(pc)
                    	<% } else if (ht.get("WASH_ETC").equals("작업지시건(phone)")) { %>
                    				작업지시건(phone)
                    	<% } else if (ht.get("WASH_ETC").equals("포괄지시건(phone)")) { %>
                    				포괄지시건(phone)
          				<% }else{ %>
          							작업지시건
          				<%} %>
          				
                    </td>
                   <td align="center"  width="15%" style="word-break:break-all;padding:0px 10px;" id="wash_etc<%=i%>">
                   		<%if(!String.valueOf(ht.get("REASON")).equals("")){%>
                   				<%=ht.get("REASON")%>
                   		<%}else{ %>			
                   			<% if (ht.get("WASH_ETC").equals("")) { %>
	                    	<% } else if (ht.get("WASH_ETC").equals("포괄지시건")) { %>
	                    	<% } else if (ht.get("WASH_ETC").equals("작업지시건(phone)")) { %>
	                    	<% } else if (ht.get("WASH_ETC").equals("포괄지시건(phone)")) { %>
	          				<% }else{ %>
          							<%=ht.get("WASH_ETC")%>
	          				<%} %>
                   		<%} %>
                   	</td>
                   	<input type='hidden' id='reg_id<%=i%>' value='<%=ht.get("REG_ID")%>'>
                </tr>
                <%  }
  					} else { %>
				<tr height="40">
					<td colspan="15" align="center">데이터가 없습니다.</td>
				</tr>
			 	<% 
			 		} %>
            </table>
	    </td>
    </tr>
  </table>
</div>
</form>
<div>

</div>
</body>
</html>
