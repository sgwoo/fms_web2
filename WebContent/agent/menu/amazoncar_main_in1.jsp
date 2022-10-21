<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	int count = 0;
	
	LoginBean login = LoginBean.getInstance();
	String acar_id = login.getCookieValue(request, "acar_id");
	
	OffAncDatabase oad = OffAncDatabase.getInstance();
	a_bean = oad.getAncLastBean();
%>

<!--공지사항-->

<html>
<HEAD>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type="text/css">
a:link { text-decoration: none;}
</style>
<script language='javascript'>
<!--
//리플달기
	function Anc_Open(bbs_id,acar_id){


		var SUBWIN="http://fms4.amazoncar.co.kr/agent_bbs/agent_c.jsp?bbs_id="+bbs_id+"&acar_id="+acar_id;	
		window.open(SUBWIN, "AncDisp", "left=100, top=50, width=650, height=600, scrollbars=yes");
	}
//-->
</script>
</HEAD>
<BODY topmargin="0" leftmargin="0" marginwidth="0" marginheight="0">
<table border=0 cellspacing=0 cellpadding=0 width=300>
<%	AncBean a_r [] = oad.getAncAll(acar_id);
String[] latestObj = new String[4]; 
    for(int i=0; i<a_r.length; i++){
        a_bean = a_r[i];
		String r_ch = a_bean.getRead_chk();
		String cont = AddUtil.replace(a_bean.getContent(),"\\","&#92;&#92;");
		String cont_title = a_bean.getTitle();
		cont_title = AddUtil.replace(cont_title,"\"","&#34;");
		cont = AddUtil.replace(cont,"\"","&#34;");
		cont = AddUtil.replace(cont,"&#39;","'+'\\'");
		cont = Util.htmlR(cont);
		if(a_bean.getBbs_st().equals("8") || a_bean.getP_view().equals("A") || a_bean.getP_view().equals("J")){ //일반공지, 업무협조, 경조사, 규정및인사
			//if(a_bean.getBbs_st().equals("6") && a_bean.getComst().equals("N"))	continue;
%>

   	<tr>
    	<td>
			<a href="javascript:parent.AncDisp('<%=a_bean.getBbs_id()%>','<%=cont_title%>','<%=cont%>')"  id="bbs_<%=a_bean.getBbs_id()%>">
		  
		  
		  <%if(a_bean.getRead_yn().equals("Y")){//필독 처리%><b><img src="/images/n_icon.gif" border=0 align=absmiddle>&nbsp;<%}%>		
		  <%if(r_ch.equals("1")){//이미본것-회색%><font color="#303030" ><%}else{//안본것-파란색%><font color="blue" ><%}%>
		  <!--제목--><%=Util.subData(String.valueOf(a_bean.getTitle()),25)%><!--작성자-->&nbsp;
		  <!--댓글관련-->
		  <%if(!a_bean.getComment_cnt().equals("")){%>
		  -댓글 <%=a_bean.getComment_cnt()%>
		  <%}%>
		  </font>
		  <%if(a_bean.getRead_yn().equals("Y")){//필독 처리%></b><%}%>					
		  <!--오늘등록분 new-->
		  <%if(a_bean.getReg_dt().equals(AddUtil.getDate())){ %>
		  &nbsp;
		  <font color="Fuchsia" size="1">
		  <b>New</b>
		  </font>
		  <%}%>
		</a>
		</td>
   	</tr>
<%		
if(!a_bean.getBbs_st().equals("5")) {
			latestObj[3] = latestObj[3] == null ? "0" : latestObj[3];

			if( i > 0 ){
			
				int preContentDt = Integer.parseInt(latestObj[3].replaceAll("-", ""));
				int contentDt = Integer.parseInt(a_bean.getReg_dt().replaceAll("-", ""));
				
				if( preContentDt < contentDt ){
					latestObj[0] = Integer.toString(a_bean.getBbs_id());
					latestObj[1] = a_bean.getTitle();
					latestObj[2] = cont;
					latestObj[3] = a_bean.getReg_dt();
				}
			}else{
				latestObj[0] = Integer.toString(a_bean.getBbs_id());
				latestObj[1] = a_bean.getTitle();
				latestObj[2] = cont;
				latestObj[3] = a_bean.getReg_dt();			
			}
		}


}
	}%>
</table>
</body>
<script>
	var obj = document.getElementById('bbs_<%=latestObj[0] %>');
	
	if( obj != null ){
		obj.click();
	}
</script>
</html>
<% latestObj = new String[4];  %>

