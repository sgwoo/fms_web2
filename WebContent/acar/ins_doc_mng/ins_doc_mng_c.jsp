<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.estimate_mng.*, acar.insur.*"%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="InsDocListBn" scope="page" class="acar.insur.InsDocListBean"/>
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
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	//공문
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	//해지보험 리스트
	Vector DocList = ai_db.getInsDocLists(doc_id);
	//보험사
	Hashtable ins_com = ai_db.getInsCom(FineDocBn.getGov_id());
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	//변수
	String var1 = e_db.getEstiSikVarCase("1", "", "ins1");//담당부서장
	String var2 = e_db.getEstiSikVarCase("1", "", "ins2");	//담당자?
	String var3 = e_db.getEstiSikVarCase("1", "", "ins_app1");//첨부서류1
	String var4 = e_db.getEstiSikVarCase("1", "", "ins_app2");//첨부서류2
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//출력하기
	function InsDocPrint(){
		var fm = document.form1;
		var SUBWIN="ins_doc_print.jsp?doc_id=<%=doc_id%>";	
		window.open(SUBWIN, "DocPrint", "left=50, top=50, width=750, height=600, scrollbars=yes, status=yes");			
	}
	//출력하기
	function InsDocPrint2(){
		var fm = document.form1;
		var SUBWIN="ins_doc_print2.jsp?doc_id=<%=doc_id%>";	
		window.open(SUBWIN, "DocPrint", "left=50, top=50, width=750, height=600, scrollbars=yes, status=yes");			
	}	
	//목록보기
	function go_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "ins_doc_mng_frame.jsp";
		fm.submit();
	}			
	//수정하기
	function fine_update(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "ins_doc_mng_u.jsp";
		fm.submit();
	}	
	
	//수정하기
	function fine_upd(){
		window.open("ins_doc_mng_u.jsp?doc_id=<%=doc_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>", "REG_FINE_GOV", "left=100, top=200, width=860, height=330, scrollbars=yes");
	}
		
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}			
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > 보험관리 >  <span class=style5>해지보험공문등록</span></span></td>	  			  
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tR>
        <td align=right><a href="javascript:go_list();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>      
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=12%>문서번호</td>
                    <td width=88%>&nbsp;<%=FineDocBn.getDoc_id()%></td>
                </tr>
                <tr> 
                    <td class='title'>시행일자</td>
                    <td>&nbsp;<%=AddUtil.getDate3(FineDocBn.getDoc_dt())%></td>
                </tr>
                <tr> 
                    <td class='title'>수신</td>
                    <td>&nbsp;<%=ins_com.get("INS_COM_NM")%>		
        			</td>
                </tr>
                <tr> 
                    <td class='title'>참조</td>
                    <td>&nbsp;<%=FineDocBn.getMng_dept()%> 
        			<%if(!FineDocBn.getMng_nm().equals("")){%>						
        			(담당자 : <%=FineDocBn.getMng_nm()%> <%=FineDocBn.getMng_pos()%>) 
        			<%}%>						
        			</td>
                </tr>
                <tr> 
                    <td class='title'>제목</td>
                    <td>&nbsp;자동차 보험 해지 요청 건</td>
                </tr>
                <tr> 
                    <td class='title'>내용</td>
                    <td>&nbsp;귀 
                    <%=FineDocBn.getGov_st()%>
                    의 무궁한 발전을 기원합니다. </td>
                </tr>		    
            </table>
        </td>
    </tr>
     <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>당사</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width=12% class='title'>담당부서장</td>
                    <td width=38%>&nbsp;<%=c_db.getNameById(FineDocBn.getH_mng_id(),"USER")%></td>
                    <td width=12% class='title'>담당자</td>
                    <td width=38%>&nbsp;<%=c_db.getNameById(FineDocBn.getB_mng_id(),"USER")%></td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr> 
        <td align="right">
	    <%if(FineDocBn.getPrint_dt().equals("")){%>
	    <a href="javascript:InsDocPrint();"><img src="/acar/images/center/button_print_gm.gif"  align="absmiddle" border="0"></a>&nbsp;&nbsp;
	    <%}else{%>
	    <img src=/acar/images/center/arrow_printd.gif align=absmiddle> : <a href="javascript:InsDocPrint();" onMouseOver="window.status=''; return true"> <%=AddUtil.ChangeDate2(FineDocBn.getPrint_dt())%> (<%=c_db.getNameById(FineDocBn.getPrint_id(), "USER")%>)</a>&nbsp;&nbsp;
	    <a href="javascript:InsDocPrint2();" onMouseOver="window.status=''; return true">..</a>&nbsp;&nbsp;
	    <%}%>	  
	    </td>
    </tr>
     <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>해지보험 리스트</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>  
    <tr> 
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width="6%" rowspan="2">연번</td>
                    <td width='13%' class='title' rowspan="2">증권번호</td>
                    <td width='12%' class='title' rowspan="2">해지구분</td>
                    <td colspan="2" class='title'>차량번호</td>
                    <td width="15%" rowspan="2" class='title'>차량명</td>
                    <td width="9%" rowspan="2" class='title'>해지일자</td>
                    <td width='21%' class='title' rowspan="2">첨부서류</td>
                </tr>
                <tr>
                    <td width='12%' class='title'>변경전</td> 
                    <td width='12%' class='title'>변경후</td>
                </tr>
              <% if(DocList.size()>0){
    				for(int i=0; i<DocList.size(); i++){ 
    					InsDocListBn = (InsDocListBean)DocList.elementAt(i); %>		
                <tr align="center"> 
                    <td><%=i+1%>
        			<input type='hidden' name='car_mng_id' value='<%=InsDocListBn.getCar_mng_id()%>'>
        			<input type='hidden' name='ins_st' value='<%=InsDocListBn.getIns_st()%>'>	
        			</td>
                    <td><%=InsDocListBn.getIns_con_no()%></td>			
                    <td><%=InsDocListBn.getExp_st()%></td>
                    <td><%=InsDocListBn.getCar_no_b()%></td>
                    <td><%=InsDocListBn.getCar_no_a()%></td>
                    <td><%=InsDocListBn.getCar_nm()%></td>
                    <td><%=AddUtil.ChangeDate2(InsDocListBn.getExp_dt())%></td>
                    <td><%if(InsDocListBn.getApp_st().equals("1")) {%><%=var3%><%}else{%><%=var4%><%}%>
                    </td>
                </tr>
    <%		}
    	}%>		
            </table>
        </td> 
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td align='right'>&nbsp;</td>
    </tr>
</table>
</form>
</body>
</html>
