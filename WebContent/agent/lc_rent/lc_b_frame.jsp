<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/agent/cookies.jsp" %>
<%@ include file="/agent/access_log.jsp" %>

<%!
  public String[] mobileTags = { "cellphone",
                                  "iemobile",
                                  "midp",
                                  "mini",
                                  "mmp",
                                  "mobile",
                                  "nokia",
                                  "pda",
                                  "phone",
                                  "pocket",
                                  "ppc",
                                  "psp",
                                  "symbian",
                                  "up.browser",
                                  "up.link",
                                  "wap",
                                  "android",
                                  "iPhone",                                                           
                                  "windows ce" };
  
  public Boolean isMobile( String browserInfo )
  {
    for ( int n=0; n<mobileTags.length; n++ )
    {
      if ( browserInfo.toLowerCase().contains( mobileTags[n].toLowerCase() ) )
      {
        return true;
      }
    }
    return false;
  }
%>

<%
	Enumeration e;	
	e = request.getHeaderNames();

  	String bInfo = request.getHeader( "user-agent" );
    
%>

<%
	int cnt = 4; //검색 라인수
	int height = (cnt*sh_line_height)+(cnt*1)+45;
%>
<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "22", "01", "02");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"1":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")		==null?"":request.getParameter("andor");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String vlaus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&from_page="+from_page+
				   	"&sh_height="+height+"";
	

%>

<HTML>
<HEAD>
<title>FMS</title>
<script language='javascript'>
</script>
</HEAD>
<frameset rows="<%=height%>, <%=AddUtil.parseInt(s_height)-height%>" border=1 name=ex>
  <frame src="./lc_b_sh.jsp<%=vlaus%>" name="c_body" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <frame src="./lc_b_sc.jsp<%=vlaus%>" name="c_foot" marginwidth=10 marginheight=10 scrolling='no' noresize>
</frameset>
</script>
</HTML>
