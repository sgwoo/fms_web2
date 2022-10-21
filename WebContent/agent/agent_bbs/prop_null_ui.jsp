<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.user_mng.*"%>
<%@ page import="acar.off_anc.*" %>
<jsp:useBean id="p_bean" class="acar.off_anc.PropBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>


<%

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");

	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	int prop_id 		= request.getParameter("prop_id")==null?0:Util.parseInt(request.getParameter("prop_id"));
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String prop_step = request.getParameter("prop_step")==null?"":request.getParameter("prop_step");
	String title 	= request.getParameter("title")==null?"":request.getParameter("title");
	String content1	= request.getParameter("content1")==null?"":request.getParameter("content1");
	String content2 = request.getParameter("content2")==null?"":request.getParameter("content2");
	String content3 = request.getParameter("content3")==null?"":request.getParameter("content3");
	String act_yn 	= request.getParameter("act_yn")==null?"":request.getParameter("act_yn");
	String act_dt 	= request.getParameter("act_dt")==null?"":request.getParameter("act_dt");
	String exp_dt 	= request.getParameter("exp_dt")==null?"":request.getParameter("exp_dt");
	int prize 		= request.getParameter("prize")==null?0:AddUtil.parseDigit(request.getParameter("prize"));
	String eval_dt 	= request.getParameter("eval_dt")==null?"":request.getParameter("eval_dt");
	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx"); //제안순번
			
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String content	= request.getParameter("content")==null?"":request.getParameter("content");
	String use_yn 	= request.getParameter("use_yn")==null?"":request.getParameter("use_yn");  //채택여부
	String jigub_dt = request.getParameter("jigub_dt")==null?"":request.getParameter("jigub_dt");
	String eval_magam = request.getParameter("eval_magam")==null?"":request.getParameter("eval_magam");
	int jigub_amt	= request.getParameter("jigub_amt")==null?0:AddUtil.parseDigit(request.getParameter("jigub_amt"));
	int eval	= request.getParameter("eval")==null?0:AddUtil.parseDigit(request.getParameter("eval"));
	String open_yn 	= request.getParameter("open_yn")==null?"N":request.getParameter("open_yn");  //실명공개
	String public_yn 	= request.getParameter("public_yn")==null?"N":request.getParameter("public_yn"); //외부공개여부 
	
	int count = 0;	
	OffPropDatabase p_db = OffPropDatabase.getInstance();	

%>
<%
	if(cmd.equals("i")){				//등록
		p_bean.setReg_id	(user_id);
		p_bean.setTitle		(title);
		p_bean.setContent1	(content1);
		p_bean.setContent2	(content2);
		p_bean.setContent3	(content3);
		p_bean.setOpen_yn	(open_yn);
		p_bean.setPublic_yn	(public_yn);
		count = p_db.insertProp(p_bean);
		
	}else if(cmd.equals("u")){
		p_bean = p_db.getPropBean(prop_id);
		if(mode.equals("1")){			//수정
			p_bean.setTitle		(title);
			p_bean.setContent1	(content1);
			p_bean.setContent2	(content2);
			p_bean.setContent3	(content3);
			p_bean.setPublic_yn	(public_yn);
			
		}else if(mode.equals("2")){		//보류,진행,완료
			p_bean.setProp_step	(prop_step);
			if (prop_step.equals("1") || prop_step.equals("2") || prop_step.equals("3") || prop_step.equals("5") ) act_yn = "";  // 수렴 또는 심사 또는 보류 또는 재심
			p_bean.setAct_yn	(act_yn);
			p_bean.setAct_dt	(act_dt);
			p_bean.setExp_dt	(exp_dt);
			p_bean.setPrize		(prize);
			p_bean.setContent	(content);
			p_bean.setUse_yn	(use_yn);
			p_bean.setJigub_dt  (jigub_dt); 
			p_bean.setJigub_amt  (jigub_amt); 
			p_bean.setEval_magam (eval_magam); 
			p_bean.setEval_dt	(eval_dt);
			p_bean.setEval	(eval);
		}
	
		count = p_db.updateProp(p_bean);
	}else if(cmd.equals("d")){			//삭제
		count = p_db.deleteProp(prop_id);
		
		//댓글리스트
		PropCommentBean pc_r [] = p_db.getPropCommentList(prop_id);
		if(pc_r.length>0)	count = p_db.deletePropComment(prop_id);
	}
	

%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='asc'	 	value='<%=asc%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>      
  <input type="hidden" name="prop_id" 	value="<%=prop_id%>">
  <input type="hidden" name="prize" 	value="<%=prize%>">
  <input type="hidden" name="idx" 		value="<%=idx%>">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">  
  <input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">  
</form>

<script language="JavaScript">
<!--
	var fm = document.form1;

	<%	if(count==1){%>
		alert("처리되었습니다.");
	<%		if(!cmd.equals("u")){%>
			fm.action="prop_s_frame.jsp";
	<%		}else{%>	
			fm.action="prop_c.jsp";
	<%		}%>
		fm.target='d_content';
	//	top.window.close();
		fm.submit();
			
	<%	}else{%> alert('에러가 발생!'); <%	}%>

//-->
</script>

</body>
</html>
