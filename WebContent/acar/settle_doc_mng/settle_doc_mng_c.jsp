<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
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
	//미수채권 리스트
	Vector FineList = FineDocDb.getSettleDocLists(doc_id);
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//수신기관 보기 
	function view_fine_gov(gov_id){
		window.open("../fine_doc_reg/fine_gov_c.jsp?gov_id="+gov_id, "view_FINE_GOV", "left=200, top=200, width=560, height=150, scrollbars=yes");
	}
	//출력하기
	function FineDocPrint(){
		var fm = document.form1;
		var SUBWIN="fine_doc_print.jsp?doc_id=<%=doc_id%>";	
		window.open(SUBWIN, "DocPrint", "left=50, top=50, width=750, height=600, scrollbars=yes, status=yes");			
	}
	//목록보기
	function go_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "settle_doc_mng_frame.jsp";
		fm.submit();
	}			
	//수정하기
	function fine_update(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "fine_doc_mng_u.jsp";
		fm.submit();
	}	
	
	//수정하기
	function fine_upd(){
		window.open("settle_doc_mng_u.jsp?doc_id=<%=doc_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>", "REG_FINE_GOV", "left=100, top=200, width=860, height=330, scrollbars=yes");
	}
		
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}			

	//수정: 스캔 보기
	function view_map(map_path){
		var size = 'width=700, height=650, scrollbars=yes';
		window.open("/data/"+map_path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
	}	
	//스캔관리 보기
	function view_scan(m_id, l_cd){
		window.open("/acar/car_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=100, width=620, height=500, scrollbars=yes");		
	}			
	
/*
	//등록
	function reg_forfeit(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "./fine_doc_mng_frame.jsp";
		fm.submit();
	}
	
	//수금관리 이동
	function forfeit_in(){
		var fm = document.form1;
		fm.gubun2.value = '6';
		fm.target = "d_content";
		fm.action = "/acar/con_forfeit/forfeit_frame_s.jsp";
		fm.submit();
	}	
	//등록하기
	function fine_gov(gov_id){
		window.open("fine_gov_info.jsp?gov_id="+gov_id, "REG_FINE_GOV", "left=200, top=200, width=550, height=150, scrollbars=yes");
	}
*/	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
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
  <table border="0" cellspacing="0" cellpadding="0" width=820>
    <tr> 
      <td><font color="navy">채권관리 -> </font><font color="red">최고장관리</font></td>
      <td align="right">
	  <%if(auth_rw.equals("6")){%><a href="javascript:fine_upd();" onMouseOver="window.status=''; return true"><img src="/images/update.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp;&nbsp;<%}%>
	  <a href="javascript:go_list();" onMouseOver="window.status=''; return true"><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
      <td align="right" width="20">&nbsp;</td>
    </tr>
    <tr> 
      <td class="line" colspan="2" width="800"> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width="80">문서번호</td>
            <td><%=FineDocBn.getDoc_id()%></td>
          </tr>
          <tr> 
            <td class='title' width="80">시행일자</td>
            <td><%=AddUtil.getDate3(FineDocBn.getDoc_dt())%></td>
          </tr>
          <tr> 
            <td width="80" rowspan="2" class='title'>수신</td>
            <td><%=FineDocBn.getGov_nm()%></td>
          </tr>
          <tr>
            <td><%=FineDocBn.getGov_addr()%></td>
          </tr>
          <tr> 
            <td class='title' width="80">참조</td>
            <td><%=FineDocBn.getMng_dept()%> 
			<%if(!FineDocBn.getMng_nm().equals("")){%>						
			(담당자 : <%=FineDocBn.getMng_nm()%> <%=FineDocBn.getMng_pos()%>) 
			<%}%>						
			</td>
          </tr>
          <tr> 
            <td class='title' width="80">제목</td>
            <td><%=FineDocBn.getTitle()%></td>
          </tr>          
          <tr> 
            <td class='title' width="80">유예기간</td>
            <td><%=AddUtil.ChangeDate2(FineDocBn.getEnd_dt())%></td>
          </tr>		
          <tr> 
            <td class='title' width="80">스캔</td>
            <td><a href="https://fms3.amazoncar.co.kr/data/stop_doc/<%=FineDocBn.getFilename()%>" target="_blank"><%=FineDocBn.getFilename()%></a></td>
          </tr>		  		  
		    		  
        </table>
      </td>
      <td width="20">&nbsp;</td>
    </tr>
    <tr> 
      <td height="21">&lt;미수채권리스트&gt;</td>
      <td align="right" height="21">&nbsp;</td>
      <td height="21">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2" class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td width="4%" class='title'>연번</td>
            <td width='12%' class='title'>계약번호</td>
            <td width='12%' class='title'>차량번호</td>
            <td width="12%" class='title'>선수금</td>
            <td width="12%" class='title'>대여료</td>
            <td width="12%" class='title'>과태료</td>
            <td width="12%" class='title'>면책금</td>
            <td width='12%' class='title'>중도해지위약금</td>
            <td width='12%' class='title'>합계</td>
          </tr>
          <% if(FineList.size()>0){
				for(int i=0; i<FineList.size(); i++){ 
					FineDocListBn = (FineDocListBean)FineList.elementAt(i); %>		  
          <tr align="center"> 
            <td><%=i+1%></td>
            <td><%=FineDocListBn.getRent_l_cd()%></td>			
            <td><%=FineDocListBn.getCar_no()%></td>
            <td><%=Util.parseDecimal(FineDocListBn.getAmt1())%></td>
            <td><%=Util.parseDecimal(FineDocListBn.getAmt2())%></td>
            <td><%=Util.parseDecimal(FineDocListBn.getAmt3())%></td>
            <td><%=Util.parseDecimal(FineDocListBn.getAmt4())%></td>
            <td><%=Util.parseDecimal(FineDocListBn.getAmt5())%></td>
            <td><%=Util.parseDecimal(FineDocListBn.getAmt6())%></td>
          </tr>
          <% 	}
			} %>
        </table>
      </td>
      <td>&nbsp;</td>	  
    </tr>
    <tr> 
      <td colspan="3">&nbsp;</td>
    </tr>
    <tr> 
      <td align='right' colspan="3">&nbsp;</td>
    </tr>
  </table>
</form>
</body>
</html>
