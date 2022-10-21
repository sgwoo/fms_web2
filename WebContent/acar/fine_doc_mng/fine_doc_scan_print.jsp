<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.* ,acar.client.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
	
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>

<style>

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

</style>
<script>

window.onbeforeprint = function(){
	//setCookie();
};

function setCookie(cName, cValue, cMinutes){

 	var expire = new Date();
    expire.setDate(expire.getMinutes() + cMinutes);
    cookies = cName + '=' + escape(cValue) + '; path=/ ; domain=.amazoncar.co.kr';
    if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
    document.cookie = cookies;
    
}

// 쿠키 가져오기
function getCookie(cName) {
    cName = cName + '=';
    var cookieData = document.cookie;
    var start = cookieData.indexOf(cName);
    var cValue = '';
    if(start != -1){
        start += cName.length;
        var end = cookieData.indexOf(';', start);
        if(end == -1)end = cookieData.length;
        cValue = cookieData.substring(start, end);
    }
    return unescape(cValue);
}

setCookie('tmp_waste', 'delete', 1);

</script>
</head>
<body leftmargin="15" topmargin="1"  >
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 

<%
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_mng_id2 = request.getParameter("rent_mng_id2")==null?"":request.getParameter("rent_mng_id2");
	String rent_l_cd2 	= request.getParameter("rent_l_cd2")==null?"":request.getParameter("rent_l_cd2");
	String client_id 		= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_s_cd 		= request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");
	String rent_st 			= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	
	double img_width 	= 680;
	double img_height 	= 1009;		
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
%>


<!--계약서외 스캔파일-->
<%
				int size = 0;
				String content_seq = "";
				String save_file1 ="";
				String save_file2 ="";
				String save_file3 ="";
				String save_file4 ="";
				String save_folder1 ="";
				String save_folder2 ="";
				String save_folder3 ="";
				String save_folder4 ="";
				
				content_seq  = rent_mng_id+rent_l_cd;
				
				//계약서 스캔파일 가져오기 + 사업자등록증.
				if(!rent_s_cd.equals("")){
					content_seq  = rent_mng_id2+rent_l_cd2;
				}
				
				Vector attach_vt = c_db.getAcarAttachFileLcScanClientList_fine(client_id, content_seq);
				int  attach_vt_size = attach_vt.size();
				
				//고객정보
				ClientBean client =  al_db.getNewClient(client_id);

   			// tip : 계약서는 반드시 계약번호로, 사업자나 신분증은 계약번호가 아닌경우도 있음. client_id로 
				for(int y=0; y< attach_vt.size(); y++){
					Hashtable aht = (Hashtable)attach_vt.elementAt(y);   
					if(aht.get("RK").equals("1") && aht.get("RK_SEQ").equals("1")){
						if((content_seq+rent_st+"17").equals(aht.get("CONTENT_SEQ"))){
							save_file1 = String.valueOf(aht.get("SAVE_FILE"));
							save_folder1 = String.valueOf(aht.get("SAVE_FOLDER"));
						}
						if((content_seq+rent_st+"18").equals(aht.get("CONTENT_SEQ"))){	
							save_file2 = String.valueOf(aht.get("SAVE_FILE"));
							save_folder2 = String.valueOf(aht.get("SAVE_FOLDER"));
						}
						if(String.valueOf( aht.get("CONTENT_SEQ")).substring(20,21).equals("2")){
							save_file3 = String.valueOf(aht.get("SAVE_FILE"));
							save_folder3 = String.valueOf(aht.get("SAVE_FOLDER"));
						}
						if(save_file3.equals("")){
								if( String.valueOf(aht.get("CONTENT_SEQ")).substring(20,21).equals("4")){
								save_file3 = String.valueOf(aht.get("SAVE_FILE"));
								save_folder3 = String.valueOf(aht.get("SAVE_FOLDER"));
							}
						}
						if(!client.getClient_st().equals("1") && !client.getClient_st().equals("2")){
								if( String.valueOf(aht.get("CONTENT_SEQ")).substring(20,21).equals("4")){
								save_file4 = String.valueOf(aht.get("SAVE_FILE"));
								save_folder4 = String.valueOf(aht.get("SAVE_FOLDER"));
							}
						}
   				}
				}
%>		
<table>
	<tr valign="top">
		<td>
			<%if(mode.equals("fine")){ %>
				<%if(!save_file1.equals("")){ %>
					<img src="https://fms3.amazoncar.co.kr<%=save_folder1%><%=save_file1%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
				<% } %>
				<%if(!save_file2.equals("")){ %>
					<img src="https://fms3.amazoncar.co.kr<%=save_folder2%><%=save_file2%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
				<% } %>
				<%if(!save_file3.equals("")){ %> 
					<img src="https://fms3.amazoncar.co.kr<%=save_folder3%><%=save_file3%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
				<%}%>
				<%if(!save_file4.equals("")){ %> 
					<img src="https://fms3.amazoncar.co.kr<%=save_folder4%><%=save_file4%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
				<% } %>
			<%}else if(mode.equals("lazy-loading")){ %>
				<%if(!save_file1.equals("")){ %>
					<img class="b-lazy" data-src="https://fms3.amazoncar.co.kr<%=save_folder1%><%=save_file1%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
				<% } %>
				<%if(!save_file2.equals("")){ %>
					<img class="b-lazy" data-src="https://fms3.amazoncar.co.kr<%=save_folder2%><%=save_file2%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
				<% } %>
				<%if(!save_file3.equals("")){ %> 
					<img class="b-lazy" data-src="https://fms3.amazoncar.co.kr<%=save_folder3%><%=save_file3%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
				<%}%>
				<%if(!save_file4.equals("")){ %> 
					<img class="b-lazy" data-src="https://fms3.amazoncar.co.kr<%=save_folder4%><%=save_file4%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
				<%}%>
			<%}%>
		</td>
	</tr>
</table>
</form>
<%if(mode.equals("lazy-loading")){ %>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/blazy@1.8.2/blazy.min.js"></script>
<script>
    var bLazy = new Blazy({ });
</script>
<%}%>
</body>
</html>
