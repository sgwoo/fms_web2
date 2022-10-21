<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.parking.*, acar.user_mng.*"%>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%
						
	
	String br_id 	= request.getParameter("br_id")==null?"S1":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"" :request.getParameter("t_wd").replaceAll(" ","");
	String brid 	= request.getParameter("brid")==null?"1":request.getParameter("brid");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String start_dt 	= request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort_gubun = request.getParameter("sort_gubun")==null?"5":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	int s_year = request.getParameter("s_year")==null?0:Util.parseDigit(request.getParameter("s_year"));
	
	String park_id = request.getParameter("park_id")==null?"":request.getParameter("park_id");
	//int park_id = request.getParameter("park_id")==null?1:Util.parseInt(request.getParameter("park_id"));
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));
	String car_no = request.getParameter("car_no")==null?"": request.getParameter("car_no");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String car_mng_id	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String init_reg_dt	= request.getParameter("init_reg_dt")==null?"":request.getParameter("init_reg_dt");
	String dpm	= request.getParameter("dpm")==null?"":request.getParameter("dpm");
	String fuel_kd	= request.getParameter("fuel_kd")==null?"":request.getParameter("fuel_kd");
	String colo	= request.getParameter("colo")==null?"":request.getParameter("colo");
	
	String picFlag = request.getParameter("picFlag")==null?"0":request.getParameter("picFlag");
	int count =0;
	
	String save_dt	= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	Vector vt = new Vector();	
	
	vt = pk_db.getParkRealList_mobile(br_id, gubun, gubun1, start_dt, end_dt,  s_cc,  s_year,  s_kd, brid, t_wd ,sort_gubun, asc, picFlag);
		
	int vt_size = vt.size();	

%>
<!DOCTYPE HTML>
<html>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta name="viewport" content="width=device-width, user-scalable=no">
<head>
<script src="https://code.jquery.com/jquery-3.1.1.min.js"
	integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8="
	crossorigin="anonymous"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.css" />
<link rel="stylesheet" href="/sh_photo/sh_photo.css" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>	
</head>
<script>
function reg_photo(carManagedId, carNo, carName){
	$("#carName").val(carName);
	$("#carManagedId").val(carManagedId);
	$("#carNo").val(carNo);
	$("#parking").val($("select option:selected").text());
	
	$("#regForm").submit();
}
</script>
<body>
	<form id="regForm" method="get" action="sh_photo_reg.jsp">
		<input type="hidden" name="carName" id="carName"/>
		<input type="hidden" name="carManagedId" id="carManagedId"/>
		<input type="hidden" name="carNo" id="carNo"/>
		<input type="hidden" name="parking" id="parking" />
		<input type="hidden" name="picFlag" id="picFlag" value="0" />
		<input type="hidden" name="parkingId" id="parkingId" value="<%=brid%>" />
	</form>
	<div class="ui container">
		<span class="sh-photo-title">차량 목록</span>
		<div class="ui label" style="margin-left:10px;cursor:pointer;" onclick="javascript:location.href='sh_photo_history.jsp'">
	    	<i class="film icon photo-history"></i>촬영 현황
	    </div>
		<div class="ui stacked segment">
			<form class="ui form" method="get" target="_self">
				<input name="br_id" type="hidden" value="S1">
				<input name="s_kd" type="hidden" value="1">
				<div class="field">
					<label>차고지 검색</label>
					<select class="ui fluid dropdown" name="brid">
						<option value="1" <%if(brid.equals("1"))%>selected<%%>>영남</option>
						<option value="3" <%if(brid.equals("3"))%>selected<%%>>부산</option>
						<option value="4" <%if(brid.equals("4"))%>selected<%%>>대전</option>
						<option value="5" <%if(brid.equals("5"))%>selected<%%>>광주</option>
						<option value="6" <%if(brid.equals("6"))%>selected<%%>>대구</option>
					</select>
				</div>
				<div class="field">
					<label>차량 번호</label> <input type="text" name="t_wd" value='<%=t_wd%>' />
				</div>
			<%-- 	<div class="field">
					<input type="radio" name="picFlag" value="0" id="photo-0" <%if(picFlag.equals("0"))%>checked<%%>>
					<label for="photo-0" style="display:inline;">사진 없음</label>&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="radio" name="picFlag" value="1" id="photo-1" <%if(picFlag.equals("1"))%>checked<%%>>
					<label for="photo-1" style="display:inline;">사진 있음</label>
				</div> --%>
				
				<button class="ui button teal" type="submit" style="width: 100%;">차량 검색</button>
			</form>
		</div> 
	</div>
	<div class="ui container">
		<h5>총 <%=vt_size%>건</h5>
		<table class="ui unstackable table">
			<tbody>
				<%
				    if ( vt_size > 0) { 		
						for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							
							Hashtable ht2 = pk_db.getRentParkIOSearch(String.valueOf(ht.get("CAR_MNG_ID")), brid );  
							String	c_id = String.valueOf(ht2.get("CAR_MNG_ID"));
							
				%>
				<tr onclick="javascript:reg_photo('<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("CAR_NO")%>','<%=ht.get("CAR_NM")%>')" style="cursor:pointer;">
					<td>
						<h4 class="ui image header">
							<div class="content">			
								<%=ht.get("CAR_NO")%>
								<div class="sub header"><%=ht.get("CAR_NM")%></div>
							</div>
						</h4>
					</td>
				</tr>
				<%	
						}
					}else{%>
				<tr>
					<td colspan="2">해당 조건에 맞는 차량이 없습니다</td>
				</tr>
				<% }%>
			</tbody>
		</table>
	</div>
</body>
</html>