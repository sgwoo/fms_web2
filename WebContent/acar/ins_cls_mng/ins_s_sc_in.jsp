<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");		
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	if(!st_dt.equals("")) st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) end_dt = AddUtil.replace(end_dt, "-", "");
	
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	Vector inss = ai_db.getInsClsMngList(br_id, gubun0, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, gubun7, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc);
	int ins_size = inss.size();
%>

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
	
	var checkflag = "false";
	function AllSelect(field){
		if(checkflag == "false"){
			for(i=0; i<field.length; i++){
				field[i].checked = true;
			}
			checkflag = "true";
			return;
		}else{
			for(i=0; i<field.length; i++){
				field[i].checked = false;
			}
			checkflag = "false";
			return;
		}
	}		
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='ins_size' value='<%=ins_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='1240'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='400' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='50' class='title'><input type="checkbox" name="all_pr" value="Y" onClick='javascript:AllSelect(this.form.pr)'></td>
                    <td width='50' class='title'>연번</td>
                    <td width='100' class='title'>차량번호</td>
                    <td width='120' class='title'>차명</td>
                    <td width='80' class='title'>해지사유</td>
              </tr>
            </table>
	    </td>
	    <td class='line' width='840'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='120' class='title'>해지사유발생일</td>
                    <td width='100' class='title'>명의이전일</td>			
                    <td width='100' class='title'>보험사</td>	
                    <td width='120' class='title'>증권번호</td>					
                    <td width='80' class='title'>청구일</td>
                    <td width='100' class='title'>환급예정금액</td>
                    <td width='80' class='title'>환급일</td>
                    <td width='80' class='title'>환급금</td>
                    <td width='60' class='title'>기타</td>			
                </tr>
            </table>
	    </td>
    </tr>    
    <%if(ins_size > 0){%>
    <tr>
	    <td class='line' width='400' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <% 		for (int i = 0 ; i < ins_size ; i++){
    			Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td width='50' align='center'><input type="checkbox" name="pr" value="<%=ins.get("CAR_MNG_ID")%><%=ins.get("INS_ST")%>" ></td> 
                    <td width='50' align='center'><a name="<%=i+1%>"><%=i+1%></a></td>
                    <td width='100' align='center'><a href="javascript:parent.insDisp('<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>', '<%=ins.get("INS_STAT")%>')" onMouseOver="window.status=''; return true"><%=ins.get("CAR_NO")%></a></td>
                    <td width='120' align='center'><span title='<%=ins.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ins.get("CAR_NM")), 5)%></span></td>
                    <td width='80' align='center'><%=ins.get("CAU")%></td>
                </tr>
              <%		}%>
            </table>
	    </td>
	    <td class='line' width='840'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%		for (int i = 0 ; i < ins_size ; i++){
    			Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td width='120' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("CH_DT")))%></td>
                    <td width='100' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("MIGR_DT")))%></td>			
                    <td width='100' align="center"><span title='<%=ins.get("INS_COM_NM")%>'><%=Util.subData(String.valueOf(ins.get("INS_COM_NM")), 6)%></span></td>
                    <td width='120' align="center"><%=ins.get("INS_CON_NO")%></td>
                    <td width='80' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("REQ_DT")))%></td>
                    <td width='100' align="center"><%=Util.parseDecimal(String.valueOf(ins.get("RTN_EST_AMT")))%></td>
                    <td width='80' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("PAY_DT")))%></td>
                    <td width='80' align="center"><%=Util.parseDecimal(String.valueOf(ins.get("PAY_AMT")))%></td>
                    <td width='60' align="center">
    			    <a href="javascript:parent.insHis('<%=ins.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
    			    </td>			
                </tr>
              <%		}%>
            </table>
	    </td>
    </tr>      
<%	}else{%>                     
    <tr>
	    <td colspan="2" align='center' class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align="center">등록된 데이타가 없습니다.</td>
                </tr>
            </table>
        </td>
    </tr>
<% 	}%>
</table>
<script language='javascript'>
<!--
//-->
</script>
</form>
</body>
</html>
