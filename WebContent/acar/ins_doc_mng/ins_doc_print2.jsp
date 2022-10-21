<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*, acar.insur.*"%>
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
	
	if(FineDocBn.getH_mng_id().equals(""))		FineDocBn.setH_mng_id(var1);
	if(FineDocBn.getB_mng_id().equals(""))		FineDocBn.setB_mng_id(var2);
	
	//담당자정보
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	UsersBean h_user = u_db.getUsersBean(FineDocBn.getH_mng_id());
	UsersBean b_user = u_db.getUsersBean(FineDocBn.getB_mng_id());
	
	Hashtable br1 = c_db.getBranch(b_user.getBr_id());
		
	//인쇄여부 수정
	if(FineDocBn.getPrint_dt().equals("")){
		FineDocDb.changePrint_dt(doc_id, user_id);
	}

	//첨부서류 길이 조정 => 해지보험은 첨부서류가 테이블에 포함되어 있어 첨부서류부분 길이 계산은 생략한다.
	int app_doc_h = 0;
	String app_doc_v = "";
	int app_doc_size = app_doc_h/20;
	
	//내용 라인수
	int tot_size = DocList.size();
	int line_h = 32;
	//페이지 길이
	int page_h = 850;
	//각 테이블 기본 길이
	int table1_h = 465;
	int table2_h = tot_size*line_h;
	int table3_h = app_doc_h+120;
	
	//출력페이지수 구하기
	int page_cnt = ((table1_h+table2_h+table3_h)/page_h);
	if((table1_h+table2_h+table3_h)%page_h != 0) page_cnt = page_cnt + 1;
	
	//마지막 테이블 길이 구하기
	int height = (page_h*page_cnt)-(table1_h+table2_h);	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function onprint(){
		factory.printing.header 	= ""; //폐이지상단 인쇄
		factory.printing.footer 	= ""; //폐이지하단 인쇄
		factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
		factory.printing.leftMargin 	= 12.0; //좌측여백   
		factory.printing.rightMargin 	= 12.0; //우측여백
		factory.printing.topMargin 	= 30.0; //상단여백    
		factory.printing.bottomMargin 	= 10.0; //하단여백
		<%if(FineDocBn.getPrint_dt().equals("")){%>	
		factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
		<%}%>
	}
//-->
</script>
</head>
<body leftmargin="15" topmargin="1" onLoad="javascript:onprint()" >
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 
<form action="" name="form1" method="POST" >
  <table width='670' height="<%=table1_h%>" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td colspan="2" height="40" align="center" style="font-size : 18pt;"><b><font face="바탕">Pick 
        amazoncar! We'll pick you up.</font></b></td>
    </tr>
    <tr> 
      <td colspan="2" height="5" align="center"></td>
    </tr>
    <tr bgcolor="#000000"> 
      <td colspan="2" align='center' height="10"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr bgcolor="#FFFFFF"> 
            <td height="40"> <table width="100%" border="0" cellspacing="0" cellpadding="5">
                <tr> 
                  <td height="20" colspan="2" style="font-size : 9pt;"><font face="바탕"><%=br1.get("BR_POST")%>
                    <%=br1.get("BR_ADDR")%></font></td>
                  <td height="20" style="font-size : 9pt;" ><font face="바탕">Tel:<%=b_user.getHot_tel()%></font></td>
                  <td height="20" style="font-size : 9pt;" ><font face="바탕">Fax:<%=br1.get("FAX")%></font></td>
                </tr>
                <tr> 
                  <td height="20" style="font-size : 9pt;"><font face="바탕"><%=h_user.getDept_nm()%>장 
                    <%=h_user.getUser_nm()%></font></td>
                  <td height="20" style="font-size : 9pt;"><font face="바탕">담당자 
                    <%=b_user.getUser_nm()%>(<%=b_user.getUser_email()%>)</font></td>
                  <td height="20" colspan="2" style="font-size : 9pt;"><font face="바탕">http://www.amazoncar.co.kr</font></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td height="20" colspan="2" align='center'></td>
    </tr>
    <tr> 
      <td height="125" colspan="2" align='center'> <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="10%" height="25" style="font-size : 10pt;"><font face="바탕">문서번호</font></td>
            <td width="3%" height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" width="87%" style="font-size : 10pt;"><font face="바탕"><%=FineDocBn.getDoc_id()%> 
              </font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕">시행일자</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕"><%=AddUtil.getDate3(FineDocBn.getDoc_dt())%></font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕">수&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
              신</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕"><%=ins_com.get("INS_COM_NM")%></font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕">참&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
              조</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕"><%=FineDocBn.getMng_dept()%> 
              <%if(!FineDocBn.getMng_nm().equals("")){%>
              &nbsp; ( <%=FineDocBn.getMng_pos()%> <%=FineDocBn.getMng_nm()%> 
              ) 
              <%}%>
              </font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕">제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
              목</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">자동차보험 해지 
              (요청)</font></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td height="20" colspan="2" align='center'></td>
    </tr>
    <tr bgcolor="#999999"> 
      <td colspan=2 align='center' height="3" bgcolor="#333333"></td>
    </tr>
    <tr> 
      <td height="20" colspan=2 align='center'>&nbsp;</td>
    </tr>
    <tr> 
      <td align='center' height="30" width="13%"><font face="바탕">&nbsp;</font></td>
      <td width="87%" height="30" style="font-size : 10pt;"><font face="바탕">1. 귀<%=FineDocBn.getGov_st()%>의 
        무궁한 발전을 기원합니다.</font></td>
    </tr>
	<!--
    <tr> 
      <td align='center' height="30"><font face="바탕">&nbsp;</font></td>
      <td height="30" style="font-size : 10pt;"><font face="바탕">2. 귀<%=FineDocBn.getGov_st()%>와 체결했던 아래 
        차량의 자동차보험 계약을 아래와 같은 사유로 보험해지를 요청하오니</font></td>
    </tr>
	-->
    <tr> 
      <td align='center' height="30"><font face="바탕">&nbsp;</font></td>
      <td height="30" style="font-size : 10pt;"><font face="바탕">2. 아래와 같이 귀<%=FineDocBn.getGov_st()%>와 체결한 자동차보험의 
        해지를 요청하오니 업무처리 바랍니다.</font></td>
    </tr>
    <tr> 
      <td height="31" colspan="2" style="font-size : 10pt;"><font face="바탕"><!-- 처리바랍니다.--></font></td>
    </tr>
    <tr> 
      <td colspan=2 align='center' height="50" style="font-size : 10pt;"><font face="바탕">== 아&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;래 
        ==</font></td>
    </tr>
    <tr bgcolor="#000000"> 
      <td colspan="2" align='center' height="10"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr bgcolor="#FFFFFF" align="center"> 
            <td style="font-size : 8pt;  font-weight:bold" rowspan="2" width="5%"><font face="바탕">연번</font></td>
            <td style="font-size : 8pt;  font-weight:bold" rowspan="2" width="15%"><font face="바탕">증권번호</font></td>
            <td style="font-size : 8pt;  font-weight:bold" rowspan="2" width="8%"><font face="바탕">해지구분</font></td>			
            <td height="25" colspan="2" style="font-size : 8pt;  font-weight:bold"><font face="바탕">차량번호</font></td>
            <td width="12%" rowspan="2" style="font-size : 8pt;  font-weight:bold"><font face="바탕">차량명</font></td>
            <td width="10%" rowspan="2" style="font-size : 8pt;  font-weight:bold"><font face="바탕">해지일자</font></td>
            <td width="24%" rowspan="2" style="font-size : 8pt;  font-weight:bold"><font face="바탕">첨부서류</font></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td width="13%" align="center" style="font-size : 8pt;  font-weight:bold"><font face="바탕">변경전</font></td>
            <td style="font-size : 8pt;  font-weight:bold" width="13%" height="25" align="center"><font face="바탕">변경후</font></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td height="2" colspan="2"></td>
    </tr>
  </table>
  <table width='670' height="<%=table2_h%>" border="0" cellpadding="0" cellspacing="0">
    <tr bgcolor="#000000">
      <td width="100%" height="10" align='center'><table width="100%" border="0" cellspacing="1" cellpadding="0">
          <% if(DocList.size()>0){
				for(int i=0; i<DocList.size(); i++){ 
					InsDocListBn = (InsDocListBean)DocList.elementAt(i); %>		
          <tr bgcolor="#FFFFFF" align="center">
            <td width="5%" height="<%=line_h%>" bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="바탕"><%=i+1%></font></td>
            <td width="15%" style="font-size : 7pt;"><font face="바탕"><%=InsDocListBn.getIns_con_no()%></font></td>
            <td width="8%" style="font-size : 8pt;"><font face="바탕"><%=InsDocListBn.getExp_st()%></font></td>			
            <td width="13%" style="font-size : 8pt;"><font face="바탕"><%=InsDocListBn.getCar_no_b()%></font></td>
            <td width="13%" style="font-size : 8pt;"><font face="바탕"><%=InsDocListBn.getCar_no_a()%></font></td>
            <td width="12%" style="font-size : 8pt;"><font face="바탕"><%=InsDocListBn.getCar_nm()%></font></td>
            <td width="10%" style="font-size : 8pt;"><font face="바탕"><%=InsDocListBn.getExp_dt()%></font></td>
            <td width="24%" style="font-size : 8pt;"><font face="바탕">
            <%if(InsDocListBn.getApp_st().equals("1")) {%><%=var3%><%}else{%><%=var4%><%}%></font></td>
          </tr>
          <% 	}
			} %>
      </table></td>
    </tr>
  </table>
  <table width='670' border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td colspan=2 align='center' height="20"><font face="바탕">&nbsp;</font></td>
    </tr>
    <tr>
      <td colspan=2 align='right' height="20" style="font-size : 10pt;"><font size="2" face="바탕">- 끝 -</font></td>
    </tr>
    <tr>
      <td colspan=2 height="20"><font face="바탕">&nbsp;</font></td>
    </tr>
    <tr>
      <td colspan="2"><font face="바탕">&nbsp;</font></td>
    </tr>
    <tr align="center">
      <td height="40" colspan="2" style="font-size : 19pt;"><font face="바탕"><b>주식회사 아마존카 대표이사 조&nbsp;&nbsp;성&nbsp;&nbsp;희</b></font></td>
    </tr>
  </table>
</form>
<DIV id=Layer1 style="Z-INDEX: 1; LEFT: 540px; WIDTH: 68px; POSITION: absolute; TOP: <%=table1_h+table2_h+table3_h-50%>px; HEIGHT: 68px"><IMG src="../../images/gikin.gif" width="110" height="110"></DIV>  
</body>
</html>
