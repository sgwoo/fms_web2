<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.parking.*, acar.user_mng.*, java.net.URLDecoder"%>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%
	String currentMonth = AddUtil.getDate(2);
	String currentYear = AddUtil.getDate(1);
	
	String type = request.getParameter("type")==null?"date":request.getParameter("type");
	String searchYear = request.getParameter("searchYear")==null?currentYear:request.getParameter("searchYear");
	String searchMonth = request.getParameter("searchMonth")==null?currentMonth:request.getParameter("searchMonth");
	
	String paramDate = searchYear + searchMonth;
	Vector vt = new Vector();
	
	vt = pk_db.getSHPhotoHistory(type,paramDate);
	
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

function submitSearchForm(){
	var startDate = $("#startYear option:selected").val() + $("#startMonth option:selected").val();
	var endDate = $("#endYear option:selected").val() + $("#endMonth option:selected").val();
	
	$("#searchFrm").submit();
}

$(document).ready(function(){
	var selectedVal = $("#selectedMonth").val();
	$("#searchMonth option[value='"+selectedVal+"']").prop("selected",true);
})
</script>
<body>
	<input type="hidden" name="selectedMonth" value="<%=searchMonth%>" id="selectedMonth" />
	<div class="ui container">
		<span class="sh-photo-title">�Կ� ��Ȳ</span>
		<div class="ui label" style="margin-left:10px;cursor:pointer;" onclick="javascript:location.href='sh_photo_list.jsp'">
	    	<i class="list icon photo-history"></i>���� ���
	    </div>
		<div class="ui stacked segment">
			<form class="ui form" method="get" target="_self">
				<input name="br_id" type="hidden" value="S1">
				<input name="s_kd" type="hidden" value="1">
				<div class="field">
					<table>
						<colgroup>
							<col width="30%"/>
							<col width="*" />
						</colgroup>
						<tr>
							<th style="color:#00c4bc">
								��ȸ ����
							</th>
							<td>
								<select class="ui fluid dropdown" style="width:150px;display:inline;" id="searchYear" name="searchYear">
									<option value="2017">2017��</option>
								</select>
								<select class="ui fluid dropdown" style="width:100px;display:inline;" id="searchMonth" name="searchMonth">
									<script>
										for(var i=1; i<13; i++){
											var value = i;
											if(i < 10){
												value = "0" + i;
											}
											document.write("<option value='"+value+"'>"+i+"��</option>");
										}
									</script>
								</select>
							</td>
						</tr>
						<tr>
							<th style="height:37px;color:#00c4bc">
								�Ǽ� ����
							</th>
							<td>
								<div class="field">
									<input type="radio" name="type" value="date" id="type-date" <%if(type.equals("date"))%>checked<%%>>
									<label for="type-date" style="display:inline;">��¥��</label>&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="radio" name="type" value="worker" id="type-worker" <%if(type.equals("worker"))%>checked<%%> >
									<label for="type-worker" style="display:inline;">�۾��ں�</label>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<button class="ui button teal" type="submit" style="width: 100%;" onclick="javascript:submitSearchForm();">�˻�</button>
			</form>
		</div> 
	</div>
	<div class="ui container">
		<table class="ui unstackable table">
			<thead>
				<tr>
					<th>
						<% if(type.equals("date")){ %> ���� <%}else{ %>�۾��� �̸�<%} %>
					</th>
					<th>�Ǽ�</th>
				</tr>
			</thead>
			<tbody>
				<%
				    if ( vt_size > 0) { 		
						for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
				%>
				<tr>
					<td><%=ht.get("STD")%></td>
					<td><%=String.format("%.1f",Double.parseDouble(ht.get("SUM").toString()))%></td>
				</tr>
				<%		}
					}else{%>
				<tr>
					<td colspan="4" style="text-align:center;">�Կ� ������ �����ϴ�</td>
				</tr>
				<%  } %>
			</tbody>
		</table>
	</div>
</body>
</html>