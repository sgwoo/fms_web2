<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	if(s_kd.equals("5")) t_wd = AddUtil.replace(t_wd, "-", "");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	
	Vector accids = as_db.getAccidPList(br_id, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc, s_st);
	int accid_size = accids.size();
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='accid_size' value='<%=accid_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='1500'>
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td colspan=2 class=line2></td>
                </tr>
                <tr id='tr_title' style='position:relative;z-index:1'>
            	    <td class='line' width='560' id='td_title' style='position:relative;'> 
            	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>            
                          <tr> 
                            <td width='80' class='title'>연번</td>
                            <td width='50' class='title'>상태</td>
                            <td width='40' class='title'>사진</td>
                            <td width='70' class='title'>사고유형</td>
                            <td width='100' class='title'>계약번호</td>
                            <td width='130' class='title'>상호</td>
                            <td width='90' class='title'>차량번호</td>
                          </tr>
                        </table>
                    </td>
	                <td class='line' width=900>
	                    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                            <tr> 
                                <td width='150' class='title'>차명</td>
                                <td width='130' class='title'>사고일시</td>
                                <td width='120' class='title'>보험접수번호</td>
                                <td width='150' class='title'>사고장소</td>
                                <td width='150' class='title'>사고내용</td>
                                <td width='100' class='title'>접수자</td>
                                <td width='100' class='title'>등록자</td>
                            </tr>
                        </table>
	                </td>
                </tr>
<%	if(accid_size > 0){%>
                <tr>
            	    <td class='line' width='560' id='td_con' style='position:relative;'> 
                	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                          <% 		for (int i = 0 ; i < accid_size ; i++){
                			Hashtable accid = (Hashtable)accids.elementAt(i);%>
                          <tr> 
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='center'><a name="<%=i+1%>"><%=i+1%> 
                              <%if(accid.get("USE_YN").equals("Y")){%>
                              <%}else{%>
                              (해약) 
                              <%}%>
                            </a></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='50' align='center'> 
                              <%if(String.valueOf(accid.get("SETTLE_ST")).equals("1")){%>
                              종결 
                              <%}else{%>
                              <font color="#FF6600">진행</font> 
                              <%}%>
                            </td>
                            <%-- <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='40' align='center'><a class=index1 href="javascript:MM_openBrWindow('attach_big_imgs2.jsp?content_code=<%//=content_code%>&content_seq=<%//=content_seq%>&seq=','popwin0','scrollbars=yes,status=yes,resizable=yes,width=660,height=608,left=50, top=50')"><%=accid.get("PIC_CNT")%></a></td> --%>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='40' align='center'><a class=index1 href="javascript:parent.AccidentDisp('<%=accid.get("RENT_MNG_ID")%>', '<%=accid.get("RENT_L_CD")%>', '<%=accid.get("CAR_MNG_ID")%>', '<%=accid.get("ACCID_ID")%>', '<%=accid.get("ACCID_ST")%>', '<%=i%>', '10')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='70' align='center'><%=accid.get("ACCID_ST_NM")%></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='100' align='center'><a href="javascript:parent.AccidentDisp('<%=accid.get("RENT_MNG_ID")%>', '<%=accid.get("RENT_L_CD")%>', '<%=accid.get("CAR_MNG_ID")%>', '<%=accid.get("ACCID_ID")%>', '<%=accid.get("ACCID_ST")%>', '<%=i%>', '0')" onMouseOver="window.status=''; return true" title='사고상세내역 보기'><%=accid.get("RENT_L_CD")%></a></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='130' align='center'> 
                              <%if(accid.get("FIRM_NM").equals("(주)아마존카") && !accid.get("CUST_NM").equals("")){%>
                              <span title='(<%=accid.get("RES_ST")%>)<%=accid.get("CUST_NM")%>'><a href="javascript:parent.view_client('<%=accid.get("RENT_MNG_ID")%>','<%=accid.get("RENT_L_CD")%>', '1')" onMouseOver="window.status=''; return true" title='계약약식내역 팝업'>(<%=accid.get("RES_ST")%>)<%=Util.subData(String.valueOf(accid.get("CUST_NM")), 5)%></a></span>	
                              <%}else{%>
                              <span title='<%=accid.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=accid.get("RENT_MNG_ID")%>', '<%=accid.get("RENT_L_CD")%>', '1')" onMouseOver="window.status=''; return true" title='계약약식내역 팝업'><%=Util.subData(String.valueOf(accid.get("FIRM_NM")), 9)%></a></span> 
                              <%}%>
                            </td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='90' align='center'><a href="javascript:parent.view_car('<%=accid.get("RENT_MNG_ID")%>', '<%=accid.get("RENT_L_CD")%>', '<%=accid.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='자동차등록내역 팝업'><%=accid.get("CAR_NO")%></a></td>
                          </tr>
                          <%		}%>
                        </table></td>
	              	  <td class='line' width='900'>
	                    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%		for (int i = 0 ; i < accid_size ; i++){
			Hashtable accid = (Hashtable)accids.elementAt(i);
			
				String content_code = "PIC_ACCID";
				String content_seq  = String.valueOf(accid.get("CAR_MNG_ID"))+""+String.valueOf(accid.get("ACCID_ID"));							
			
			%>
                          <tr> 
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='150' align='center'><span title='<%=accid.get("CAR_NM")%> <%=accid.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(accid.get("CAR_NM"))+" "+String.valueOf(accid.get("CAR_NAME")), 12)%></span></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='130' align='center'><%=AddUtil.ChangeDate3(String.valueOf(accid.get("ACCID_DT")))%></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='120' align="center"><%=accid.get("OUR_NUM")%></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='150'>&nbsp;<span title='<%=accid.get("ACCID_ADDR")%>'><%=Util.subData(String.valueOf(accid.get("ACCID_ADDR")), 11)%></span></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='150'>&nbsp;<span title='<%=accid.get("ACCID_CONT")%> <%=accid.get("ACCID_CONT2")%>'><%=Util.subData(String.valueOf(accid.get("ACCID_CONT"))+" "+String.valueOf(accid.get("ACCID_CONT2")), 11)%></span></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='100' align='center'><%=c_db.getNameById(String.valueOf(accid.get("ACC_ID")), "USER")%></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='100' align='center'><%=c_db.getNameById(String.valueOf(accid.get("REG_ID")), "USER")%></td>                            
                          </tr>
          <%		}%>
                        </table>
	                </td>
                </tr>
<%	}else{%>                     
                <tr>
            	  <td class='line' width='560' id='td_con' style='position:relative;'> 
            	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                      <tr> 
                        <td align='center'>등록된 데이타가 없습니다</td>
                      </tr>
                    </table></td>
	                <td class='line' width='900'>
        	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                  <tr>
        		  <td>&nbsp;</td>
        		</tr>
        	  </table>
	    </td>
  </tr>
<% 	}%>
</table>
<script language='javascript'>
<!--
/*	var fm 		= document.form1;
	var p_fm	= parent.form1;
	var cnt 	= fm.fee_size.value;
	
	var i_amt = 0;
	
	if(cnt > 1){
		for(var i = 0 ; i < cnt ; i++){
			i_amt   += toInt(parseDigit(fm.amt[i].value));
		}
	}else if(cnt == 1){
		i_amt   += toInt(parseDigit(fm.amt.value));	
	}		*/
-->
</script>
 </td>
    </tr>
</table>
</form>
</body>
</html>
