<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, java.text.*, java.util.*,jxl.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	Vector vt = FineDocDb.getMyAccidDocLists_2(doc_id);
	int vt_size = vt.size();
	
	Date d = new Date();
   	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   	//System.out.println("현재날짜 : "+ sdf.format(d));
   	String filename = sdf.format(d)+"_휴대차료리스트.xls";
   	filename = java.net.URLEncoder.encode(filename, "UTF-8");
   	response.setContentType("application/octer-stream");
   	response.setHeader("Content-Transper-Encoding", "binary");
   	response.setHeader("Content-Disposition","attachment;filename=\"" + filename + "\"");
   	response.setHeader("Content-Description", "JSP Generated Data");
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
</head>
<body>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='doc_id' value='<%=doc_id%>'>
<input type='hidden' name='gov_nm' value='<%=FineDocBn.getGov_nm()%>'>
<input type='hidden' name='doc_title' value='<%=FineDocBn.getTitle()%>'>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr> 
      <td align="center"> <h2>휴/대차료 리스트</h2></td>
    </tr>    
    <tr>
        <td class=line2></td>
    </tr>
	<tr> 
      <td class="line">
        <table border="1" cellspacing="1" cellpadding="0" width='100%'>
         <tr> 
            <td class='title' width="4%" >연번</td>
            <td class='title' width="8%">차량번호</td>
            <td class='title' width="8%">상호</td>
            <td class='title' width="8%">연락처</td>
            <td class='title' width="6%">사고구분</td>
			<td class='title' width="10%">보험번호</td>
            <td class='title' width="8%">청구일자</td>						
            <td class='title' width="7%">청구액</td>									
            <td class='title' width="8%">입금일자</td>												
            <td class='title' width="7%">입금액</td>
            <td class='title' width="7%">차액</td>
            <td class='title' width="7%">이자</td>
            <td class='title' width="8%">계</td>
          </tr>
 <% 	
           if(vt_size > 0){
				for(int i=0; i<vt.size(); i++){ 
					Hashtable ht = (Hashtable)vt.elementAt(i);
					if(AddUtil.parseInt(String.valueOf(ht.get("AMT5")))==0){
						ht.put("AMT5", String.valueOf(ht.get("AMT3")));						
					}
					%>	         

            <tr align="center"> 
            <td><%=i+1%></td>
            <td><%=ht.get("OUR_CAR_NO")%></td>			
            <td><%=ht.get("FIRM_NM")%></td>
            <td><%=ht.get("INS_TEL")%></td>
            <td><%=ht.get("ACCID_ST")%>[<font color="red"><%=ht.get("OT_FAULT_PER")%></font>]</td>
			<td><%=ht.get("INS_NUM")%></td>
            <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
            <td align='right'><%=Util.parseDecimal(ht.get("AMT1"))%>&nbsp;</td>
            <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
            <td align='right'><%=Util.parseDecimal(ht.get("AMT2"))%>&nbsp;</td>
            <td align='right'><%=Util.parseDecimal(ht.get("AMT3"))%>&nbsp;</td>
            <td align='right'><%=Util.parseDecimal(ht.get("AMT4"))%>&nbsp;</td>
            <td align='right'><%=Util.parseDecimal(ht.get("AMT5"))%>&nbsp;</td>

		    
          </tr>
          <% 	}
			} %>
        </table>
      </td>
      <td>&nbsp;</td>	  
    </tr>
</table>
</form>
</body>
</html>

