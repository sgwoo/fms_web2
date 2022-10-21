<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*,acar.common.*" %>
<jsp:useBean id="bme_bean" class="acar.user_mng.MenuBean" scope="page"/>
<jsp:useBean id="sme_bean" class="acar.user_mng.MenuBean" scope="page"/>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String m_st = request.getParameter("m_st")==null?"01":request.getParameter("m_st");
	String m_st2 = request.getParameter("m_st2")==null?"":request.getParameter("m_st2");
	String m_cd = request.getParameter("m_cd")==null?"":request.getParameter("m_cd");
	String m_nm = request.getParameter("m_nm")==null?"":request.getParameter("m_nm");
	String url = request.getParameter("url")==null?"":request.getParameter("url");
	String note = request.getParameter("note")==null?"":request.getParameter("note");
	String base = request.getParameter("base")==null?"":request.getParameter("base");
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	String auth = request.getParameter("auth")==null?"1":request.getParameter("auth");
	int count = 0;
	
	if(cmd.equals("i")||cmd.equals("u")){
		sme_bean.setM_st(m_st);
		sme_bean.setM_st2(m_st2);
		sme_bean.setM_cd(m_cd);
		sme_bean.setM_nm(m_nm);
		sme_bean.setUrl(url);
		sme_bean.setNote(note);
		sme_bean.setSeq(seq);
		sme_bean.setBase(base);
		if(cmd.equals("i")){
			count = umd.insertXmlMaMenu(sme_bean,"s");
		}else if(cmd.equals("u")){
			count = umd.updateXmlMaMenu(sme_bean);
		}
	}else if(cmd.equals("d")){
    	String code [] = null;
    	code = request.getParameterValues("ch_m_cd");
	    Vector v = new Vector();
	    Throwable error = null;
	    if(code != null && code.length > 0){
	        for(int i=0; i<code.length; i++){
	            try{
		            String val [] = {code[i]};
	                v.addElement(val);
	            }catch(NoSuchElementException  nse){
	                error = nse;
	            }
	        }
	    }
	    count = umd.deleteSXmlMaMenu(m_st, m_st2, v);
	}else if(cmd.equals("auth")){
		
		String  search_auth = "";
		
		//담당자 리스트
		Vector users = c_db.getUserList("", "", "EMP", "Y");
		int user_size = users.size();
		if(user_size > 0){
			for(int i = 0 ; i < user_size ; i++){
				Hashtable user = (Hashtable)users.elementAt(i);
				search_auth = umd.getXmlMaMenuAuth(String.valueOf(user.get("USER_ID")), m_st, m_st2, m_cd);
				//System.out.println(String.valueOf(user.get("USER_ID"))+" "+search_auth+" "+auth);
				if(!String.valueOf(user.get("DEPT_ID")).equals("8888")){
					if(search_auth.equals("")){
						if(umd.setXmlMenuBaseAuth(m_st, m_st2, m_cd, String.valueOf(user.get("USER_ID")), auth)) count=1;
					}else if(search_auth.equals("0")){
						if(umd.updateXmlMenuBaseAuth(m_st, m_st2, m_cd, String.valueOf(user.get("USER_ID")), auth)) count=1;
					}
				}
			}
		}
    }
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
</head>
<body leftmargin="15">
<script>
<%	if(cmd.equals("u")){
		if(count==1){%>
	alert("정상적으로 수정되었습니다.");
	parent.SMenuSearch();
<%		}
	}else if(cmd.equals("i")){
		if(count==1){%>
	alert("정상적으로 등록되었습니다.");
	parent.SMenuSearch();
<%		}
	}else if(cmd.equals("d")){
		if(count==1){%>
	alert("정상적으로 삭제되었습니다.");
	parent.SMenuSearch();
<%		}
	}else if(cmd.equals("auth")){
		if(count==1){%>
	alert("정상적으로 부여하였습니다.");
<%		}
	}%>
</script>
</body>
</html>