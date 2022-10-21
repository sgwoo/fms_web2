<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.database.* ,acar.util.*, acar.common.*"%>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	String carManagedId = request.getParameter("carManagedId")==null?"":request.getParameter("carManagedId");
	String carNo = request.getParameter("carNo")==null?"":request.getParameter("carNo");
	String carName = request.getParameter("carName")==null?"":request.getParameter("carName");
	String parking = request.getParameter("parking")==null?"":request.getParameter("parking");
	String parkingId = request.getParameter("parkingId")==null?"":request.getParameter("parkingId");
	
	String content_code = "APPRSL";
	String seq[] = { "5","앞면", "3","후면", "1","측면1", "4" ,"측면2","2","내부1","6","내부2","7","내부3"}; //,"6","내부2","7","내부3","8","내부4"

%>
<!DOCTYPE HTML>
<html>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta name="viewport" content="width=device-width, user-scalable=no">
<head>
<script src="https://code.jquery.com/jquery-3.1.1.min.js"	integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8="	crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.css" />
<link rel="stylesheet" href="/sh_photo/sh_photo.css" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>	
<script language='javascript'>
$(document).ready(function(){
	
	var loginId = $.cookie("sh_photo_loginId").split(",")[0];
	var workId = $.cookie("sh_photo_loginId").split(",")[1];
	
	$("#loginId").val(loginId);
	$("#workId").val(workId);
	var count =0;
	$("#submitBtn").click(function(){
		var flag = true;
		$("input[type='file']").each(function(){
		if(count <= 5){
			if($(this).val() == null || $(this).val() == ""){
				alert("전체 항목을 촬영하신 후 등록하셔야 합니다");
				flag = false;
				return false;
			}
			count++;
		}
		});
		if(flag){
			save();	
		}else{
			return false;
		}
	})
})

//등록하기
function save(){
	fm = document.form1;		
	if(!confirm("해당 파일을 등록하시겠습니까?")) return;
	var values = $("#rewardFrm").serialize().replace(/%/g, '%25');
	var url = "sh_photo_reward.jsp?"+values;
	
	$("#submitBtn").attr("disabled","disabled");
	
	<%-- fm.action = "/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.APPRSL%>"; --%>		
 	fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.APPRSL%>"; 		
	fm.target = "_blank";
	fm.submit();
	
	$.ajax({
		url:url,
		type:'GET'
	});	
	
	//location.reload();
}

function go_list(){
	fm = document.form1;		
	fm.action = "/sh_photo/sh_photo_list.jsp";		
	fm.target = "_self";
	fm.submit();
}
</script>
</head>
<body>
	<form id="rewardFrm" name="rewardFrm" action="sh_photo_reward.jsp" method="get">
		<input type="hidden" name="carManagedId" id="carManagedId" value="<%=carManagedId%>"/>
		<input type="hidden" name="carNumber" id="carNumber" value="<%=carNo%>"/>
		<input type="hidden" name="carName" id="carName" value="<%=carName%>"/>
		<input type="hidden" name="workId" id="workId" value=""/>
		<input type="hidden" name="loginId" id="loginId" value=""/>
	</form>
	<div class="container">
		<span class="sh-photo-title">사진 등록</span>
		<div class="ui label" style="margin-left:10px;cursor:pointer;" onclick="javascript:location.href='sh_photo_list.jsp'">
	    	<i class="list icon photo-history"></i>차량 목록
	    </div>
		<div class="ui stacked segment">
				<div class="field">
					<label>차량번호 : <%=carNo%></label> <br/>
					<label>차명 : <%=carName%></label>
				</div>
		</div>
		<form name="form1" action="" method='post' enctype="multipart/form-data">
			<input type='hidden' name='carManagedId' value='<%=carManagedId%>'>
			<input type='hidden' name='carNo' value='<%=carNo%>'>
			<input type='hidden' name='carName' value='<%=carName%>'>
			<input type='hidden' name='parking' value='<%=parking%>'>
			<input type='hidden' name='parkingId' value='<%=parkingId%>'>
			<table class="ui unstackable table">
				  <thead>
				    <tr>
				      <th style="width: 15%;">항목</th>
				      <th style="width: 40%;">등록</th>
				      <th class="right aligned" style="width: 20%;">미리보기</th>
				    </tr>
				  </thead>
				  <tbody>
				  	<%
				  		int photoCount = 0;
				  		for(int i=0;i<seq.length;i += 2){
				  			String content_seq  = carManagedId+""+seq[i];
							Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
							int attach_vt_size = attach_vt.size();					  	
				  	%>
				  		<tr>
						      <td><%=seq[i+1]%></td>
						      
						      <%
						      		if(attach_vt_size > 0 && !carManagedId.equals("")){
						      		    	photoCount ++;
						      				for (int j = 0 ; j < attach_vt_size ; j++){
    											Hashtable ht = (Hashtable)attach_vt.elementAt(j);%>
    											 <td><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>   			
												</td>
    											 <td class="right aligned">
    											 	<a href="https://fms3.amazoncar.co.kr/fms2/attach/download2.jsp?SEQ=<%=ht.get("SEQ")%>&SIZE=<%=ht.get("FILE_SIZE")%>" target='_blank'>
    											 		<img name="carImg" src="https://fms3.amazoncar.co.kr<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>" border="0" width="66" height="53">
    											 	</a>
    											 </td>
    								<%}
						      		}else{%>
						      			<td><input type="file" name="file" class="custom-style" style="width: 70%;" />
													     <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=content_seq%>'>
							                          <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.APPRSL%>'>        			
										</td>
						      			 <td class="right aligned">None</td>
						      <%} %>
						     
				    	</tr>
				  <%	} 	%>
				    
				  </tbody>
				</table>
				<% if(photoCount < 8){  //사진 갯수가 8개 다 있으면 버튼을 보여주지 않는다 %>
					<button class="ui button teal" id="submitBtn" type="button" style="width: 100%;">사진 등록</button>
				<% } %>
		</form>
	</div>
	<iframe src="" name="iframe" style="width:1px; height:1px;"/>
</body>
</html>