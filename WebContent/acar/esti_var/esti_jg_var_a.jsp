<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiShVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String sh_code = request.getParameter("sh_code")==null?"":request.getParameter("sh_code");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int count = 0;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	bean.setSh_code		(sh_code);
	bean.setSeq			(seq);
	bean.setCars		(request.getParameter("cars")==null?"":request.getParameter("cars"));
	bean.setJanga24		(request.getParameter("janga24")==null?0:AddUtil.parseFloat(request.getParameter("janga24")));
	bean.setJeep_yn		(request.getParameter("jeep_yn")==null?"":request.getParameter("jeep_yn"));
	bean.setRentcar		(request.getParameter("rentcar")==null?"":request.getParameter("rentcar"));
	bean.setSvn_nn_yn	(request.getParameter("svn_nn_yn")==null?"":request.getParameter("svn_nn_yn"));
	bean.setLpg_ga_yn	(request.getParameter("lpg_ga_yn")==null?"":request.getParameter("lpg_ga_yn"));
	bean.setLpg_amt		(request.getParameter("lpg_amt")==null?0:AddUtil.parseDigit(request.getParameter("lpg_amt")));
	bean.setLpg_add_amt	(request.getParameter("lpg_add_amt")==null?0:AddUtil.parseDigit(request.getParameter("lpg_add_amt")));
	bean.setReg_dt		(request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt"));
	bean.setTaksong_se	(request.getParameter("taksong_se")==null?0:AddUtil.parseDigit(request.getParameter("taksong_se")));
	bean.setTaksong_bu	(request.getParameter("taksong_bu")==null?0:AddUtil.parseDigit(request.getParameter("taksong_bu")));
	bean.setAf_m12_24	(request.getParameter("af_m12_24")==null?0:AddUtil.parseFloat(request.getParameter("af_m12_24")));
	bean.setAf_m36		(request.getParameter("af_m36")==null?0:AddUtil.parseFloat(request.getParameter("af_m36")));
	bean.setAf_m48_60	(request.getParameter("af_m48_60")==null?0:AddUtil.parseDigit(request.getParameter("af_m48_60")));
	
	String sp_seq[] 	= request.getParameterValues("sp_seq");
	String tax_st_dt[] 	= request.getParameterValues("tax_st_dt");
	String tax_end_dt[] = request.getParameterValues("tax_end_dt");
	String sp_tax[] 	= request.getParameterValues("sp_tax");
	
	if(cmd.equals("i") || cmd.equals("up")){
		seq 	= e_db.insertEstiShVar(bean);
		//특소세 생성
		if(cmd.equals("i")){
			for(int i=0;i < sp_seq.length;i++){
				count 	= e_db.insertSpTax(sh_code, sp_seq[i], tax_st_dt[i], tax_end_dt[i], sp_tax[i]);
			}
		}
	}else if(cmd.equals("u")){
		count 	= e_db.updateEstiShVar(bean);
	}else if(cmd.equals("d")){
		count 	= e_db.deleteEstiShVar(sh_code);
	}else if(cmd.equals("add")){
			for(int i=0;i < sp_seq.length;i++){
				if(tax_end_dt[i].equals(""))	tax_end_dt[i] = "99999999";
				count 	= e_db.insertSpTax(sh_code, sp_seq[i], tax_st_dt[i], tax_end_dt[i], sp_tax[i]);
			}
	}
%>
<html>
<head>

<title>차종</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="esti_sh_var_i.jsp" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">        
  <input type="hidden" name="sh_code" value="<%=sh_code%>">          
  <input type="hidden" name="seq" value="<%=seq%>">          
  <input type="hidden" name="cmd" value="u">
</form>
<script>
<%	if(cmd.equals("u")){
		if(count==1){%>
		alert("정상적으로 수정되었습니다.");
		document.form1.target='SHVar';
		document.form1.submit();		
<%		}else{%>
		alert("에러발생!");
<%		}
	}else if(cmd.equals("d")){
		if(count==1){%>
		alert("정상적으로 삭제되었습니다.");
		parent.window.close();
		parent.opener.reload()
<%		}else{%>
		alert("에러발생!");
<%		}
	}else{
		if(!seq.equals("")){%>
		alert("정상적으로 등록되었습니다.");
		document.form1.target='SHVar';
		document.form1.submit();		
<%		}else{%>
		alert("에러발생!");
<%		}
	}	%>
</script>
</body>
</html>
