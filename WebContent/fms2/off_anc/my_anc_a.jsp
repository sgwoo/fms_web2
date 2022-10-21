<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String bbs_id 		= request.getParameter("bbs_id")==null?"":request.getParameter("bbs_id");
	String params 		= request.getParameter("params")==null?"":request.getParameter("params");
	int count = 0;
	int total_cnt = 0;
	boolean result = false;
	
	OffAncDatabase oad = OffAncDatabase.getInstance();
	
	/* 모드(mode) : MIA:마이공지사항 일괄등록 / MDA:마이공지사항 일괄삭제 / MI:마이공지사항 한건 등록 / MD:마이공지사항 한건 삭제	*/
	/*			   IIA:중요공지사항 일괄등록 / IDA:중요공지사항 일괄삭제 / II:중요공지사항 한건 등록 / ID:중요공지사항 한건 삭제 	*/	
	
	if(mode.equals("MI")||mode.equals("MD")){	//마이공지사항 한건 등록, 한건 삭제
		
		count = oad.updateMyAnc(bbs_id, user_id, mode);
		if(count==1) result = true;
	
	}else if(mode.equals("MIA")||mode.equals("MDA")){	//마이공지사항 일괄등록, 일괄삭제
		
		if(mode.equals("MIA")){		 	mode = "MI";		}
		else if(mode.equals("MDA")){ 	mode = "MD";		}
	
		String[] params_arr = params.split(",");
	
		for(int i=1; i<params_arr.length; i++){			
			String[] param = params_arr[i].split("/");				
			bbs_id = param[0];		//공지사항 1건의 id
			if(param.length > 1){	//공지사항 1건에 등록된 아이디가 있는 경우
				
				String[] myBbs_list = param[1].split("A");
				boolean mybbs_on_chk = false;
				
				for(int j=1; j<myBbs_list.length; j++){
					//뽑아낸 아이디가 현재 유저아이디와 같은지를 체크해 추가/삭제 여부 체크
					if(user_id.equals(myBbs_list[j])){
						mybbs_on_chk = true;
					}
				}
				if(mode.equals("MI")){
					if(mybbs_on_chk == false){
						count = oad.updateMyAnc(bbs_id, user_id, mode);
					}else{	count = 1;	}
				}else if(mode.equals("MD")){
					if(mybbs_on_chk == true){
						count = oad.updateMyAnc(bbs_id, user_id, mode);
					}else{	count = 1;	}
				}
			}else{	//아직 한건도 등록되지않은 공지사항의 경우 (추가/삭제 모두 이곳에서 처리)
				count = oad.updateMyAnc(bbs_id, user_id, mode);
			}
			if(count == 1){		total_cnt ++;	}
			if(total_cnt ==(params_arr.length-1)){	result = true;	}
		}
	}else if(mode.equals("II")||mode.equals("ID")){	//중요공지사항 한건 등록, 한건 삭제
		
		count = oad.updateImportAnc(bbs_id, mode);
		if(count==1) result = true;
	
	}else if(mode.equals("IIA")||mode.equals("IDA")){	//중요공지사항 일괄등록, 일괄삭제
		
		if(mode.equals("IIA")){		 	mode = "II";		}
		else if(mode.equals("IDA")){ 	mode = "ID";		}
		
		String[] params_arr = params.split(",");
		
		for(int i=1; i<params_arr.length; i++){			
			String[] param = params_arr[i].split("/");				
			bbs_id = param[0];		//공지사항 1건의 id
			count = oad.updateImportAnc(bbs_id, mode);
			
			if(count == 1){		total_cnt ++;	}
			if(total_cnt ==(params_arr.length-1)){	result = true;	}
		}
	}
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
var result 	= <%=result%>;
if(result==true){
	alert("정상처리되었습니다.");
	window.opener.document.location.reload();
	window.close();
}else{
	alert("처리 중 에러발생! 관리자에게 문의 하세요.");
	window.close();
}

</script>
</head>
<body>
</body>
</html>