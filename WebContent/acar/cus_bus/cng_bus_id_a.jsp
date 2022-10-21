<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title></head>
<body>
<%

	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
		
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String with_reg  	= request.getParameter("with_reg")==null?"N":request.getParameter("with_reg");
	
	String old_value  	= request.getParameter("old_value")==null?"":request.getParameter("old_value");
	String new_value  	= request.getParameter("new_value")==null?"":request.getParameter("new_value");
	String cng_cau  	= request.getParameter("cng_cau")==null?"":request.getParameter("cng_cau");
	String[] ch_call = request.getParameterValues("ch_all");
	
		//로그인 사용자정보
	LoginBean login = LoginBean.getInstance();
	String user_id 	= login.getCookieValue(request, "acar_id");
	String br_id 	= login.getCookieValue(request, "acar_br");
	

	int vid_size = ch_call.length;
									
	boolean flag = true;
	int count =0;
	boolean flag1 = true;
			
	String value[] = new String[5];
	
	String rent_mng_id	="";
	String rent_l_cd	="";
	String rent_way		="";
		
	for(int i=0; i < vid_size; i++){
		
		StringTokenizer st = new StringTokenizer(ch_call[i],"^");
		int s=0; 
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;
		}
		
		rent_mng_id		= value[0];
		rent_l_cd	= value[1];
		rent_way	= value[2];
			
			
		//계약정보에 영업담당자 변경
							
		if(!rent_l_cd.equals("")){
			//계약정보
			LcRentCngHBean bean = new LcRentCngHBean();
			
			bean.setRent_mng_id	(rent_mng_id);
			bean.setRent_l_cd	(rent_l_cd);
			bean.setCng_item	(cng_item);
			bean.setOld_value	(old_value);
			bean.setNew_value	(new_value);
			bean.setCng_cau		(cng_cau);
			bean.setCng_id		(user_id);
	
			flag = a_db.updateLcRentCngH(bean);
			
			if(rent_way.equals("일반식") ){
				
				bean.setRent_mng_id	(rent_mng_id);
				bean.setRent_l_cd	(rent_l_cd);
				bean.setCng_item	("mng_id");
				bean.setOld_value	(old_value);
				bean.setNew_value	(new_value);
				bean.setCng_cau		(cng_cau);
				bean.setCng_id		(user_id);
				
				flag = a_db.updateLcRentCngH(bean);
			}
	   }	
	}

%>
<form name='form1' method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
</form>

<script language='javascript'>
<%	if(!flag){  %>
		alert('오류발생!');
		location='about:blank';		
<%	}else if(count == 1){%>
		alert('오류발생!');
		location='about:blank';		
<%	}else{%>
		alert('처리되었습니다');	
		close();
<%	}%>
</script>
종료
</body>
</html>
