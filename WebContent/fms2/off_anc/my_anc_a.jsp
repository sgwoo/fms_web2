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
	
	/* ���(mode) : MIA:���̰������� �ϰ���� / MDA:���̰������� �ϰ����� / MI:���̰������� �Ѱ� ��� / MD:���̰������� �Ѱ� ����	*/
	/*			   IIA:�߿�������� �ϰ���� / IDA:�߿�������� �ϰ����� / II:�߿�������� �Ѱ� ��� / ID:�߿�������� �Ѱ� ���� 	*/	
	
	if(mode.equals("MI")||mode.equals("MD")){	//���̰������� �Ѱ� ���, �Ѱ� ����
		
		count = oad.updateMyAnc(bbs_id, user_id, mode);
		if(count==1) result = true;
	
	}else if(mode.equals("MIA")||mode.equals("MDA")){	//���̰������� �ϰ����, �ϰ�����
		
		if(mode.equals("MIA")){		 	mode = "MI";		}
		else if(mode.equals("MDA")){ 	mode = "MD";		}
	
		String[] params_arr = params.split(",");
	
		for(int i=1; i<params_arr.length; i++){			
			String[] param = params_arr[i].split("/");				
			bbs_id = param[0];		//�������� 1���� id
			if(param.length > 1){	//�������� 1�ǿ� ��ϵ� ���̵� �ִ� ���
				
				String[] myBbs_list = param[1].split("A");
				boolean mybbs_on_chk = false;
				
				for(int j=1; j<myBbs_list.length; j++){
					//�̾Ƴ� ���̵� ���� �������̵�� �������� üũ�� �߰�/���� ���� üũ
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
			}else{	//���� �Ѱǵ� ��ϵ������� ���������� ��� (�߰�/���� ��� �̰����� ó��)
				count = oad.updateMyAnc(bbs_id, user_id, mode);
			}
			if(count == 1){		total_cnt ++;	}
			if(total_cnt ==(params_arr.length-1)){	result = true;	}
		}
	}else if(mode.equals("II")||mode.equals("ID")){	//�߿�������� �Ѱ� ���, �Ѱ� ����
		
		count = oad.updateImportAnc(bbs_id, mode);
		if(count==1) result = true;
	
	}else if(mode.equals("IIA")||mode.equals("IDA")){	//�߿�������� �ϰ����, �ϰ�����
		
		if(mode.equals("IIA")){		 	mode = "II";		}
		else if(mode.equals("IDA")){ 	mode = "ID";		}
		
		String[] params_arr = params.split(",");
		
		for(int i=1; i<params_arr.length; i++){			
			String[] param = params_arr[i].split("/");				
			bbs_id = param[0];		//�������� 1���� id
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
	alert("����ó���Ǿ����ϴ�.");
	window.opener.document.location.reload();
	window.close();
}else{
	alert("ó�� �� �����߻�! �����ڿ��� ���� �ϼ���.");
	window.close();
}

</script>
</head>
<body>
</body>
</html>