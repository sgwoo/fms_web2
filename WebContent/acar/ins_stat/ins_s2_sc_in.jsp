<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>
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
	
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
		return;
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:init()">
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
	String gubun6 = request.getParameter("gubun6")==null?"3":request.getParameter("gubun6");	
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
		
	Vector inss = ai_db.getInsStatList1(br_id, gubun1, gubun2, gubun3, gubun4, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc, s_st, "1");
	int ins_size = inss.size();
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='ins_size' value='<%=ins_size%>'>
<input type='hidden' name='ins_com_id' value=''>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='100%' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='2%' class='title'>연번</td>
                    <td width='3%' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
                    <td width='9%' class='title'>계약번호</td>
                    <td width='10%' class='title'>상호</td>
                    <td width='8%' class='title'>차량번호</td>
                    <td width='14%' class='title'>차대번호</td>					
                    <td width='13%' class='title'>차명</td>
                    <td width='6%' class='title'>차명코드</td>
                    <td width='6%' class='title'>차종</td>					
                    <td width='6%' class='title'>보험회사</td>
                    <td width='7%' class='title'>보험시작일</td>
                    <td width='7%' class='title'>보험만료일<br>매입옵션일<br>명의이전일</td>						
                    <td width='5%' class='title'>갱신<a href="javascript:parent.view_ins_renew();"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="갱신예정리스트"></a></td>
                    <td width='5%' class='title'>해지</td>
                </tr>
            </table>
	    </td>
	<!--
	<td class='line' width='60'>
	    <table border="0" cellspacing="1" cellpadding="0" width='60'>
          <tr> 
            <td width='30' class='title'>갱신</td>
            <td width='30' class='title'>해지</td>		  
          </tr>
        </table>
	</td>-->
    </tr>
<%	if(ins_size > 0){%>
    <tr>
	    <td class='line' width='100%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <% 		for (int i = 0 ; i < ins_size ; i++){
    			Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='2%' align='center'><a name="<%=i+1%>"><%=i+1%> 
                      <%if(ins.get("USE_YN").equals("Y")){%>
                      <%}else{%>
                      (해약) 
                      <%}%>
                      </a></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='3%' align='center'><input type="checkbox" name="ch_cd" value="<%=ins.get("RENT_MNG_ID")%><%=ins.get("RENT_L_CD")%><%=ins.get("CAR_MNG_ID")%><%=ins.get("INS_ST")%>"></td>  
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='9%' align='center'><a href="javascript:parent.insDisp('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>', '<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>')" onMouseOver="window.status=''; return true"><%=ins.get("RENT_L_CD")%></a></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='10%' align='center'><span title='<%=ins.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>', '1')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(ins.get("FIRM_NM")), 7)%></a></span>
                        <%if(!String.valueOf(ins.get("CON_F_NM")).equals("아마존카")){%>
                        <br>(고객피보험)
                        <%}%>
                    </td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='8%' align='center'><%=ins.get("CAR_NO")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='14%' align='center'><%=ins.get("CAR_NUM")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='13%' align='center'><%=ins.get("CAR_NM")%> <%=ins.get("CAR_NAME")%><!--<span title='<%=ins.get("CAR_NM")%> <%=ins.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(ins.get("CAR_NM"))+" "+String.valueOf(ins.get("CAR_NAME")), 20)%></span>--></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='6%' align='center'><%=ins.get("JG_CODE")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='6%' align='center'><%=ins.get("CAR_KD")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='6%' align='center'><%=ins.get("INS_COM_NM")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='7%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_START_DT")))%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='7%' align="center"><a href="javascript:parent.view_scan('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='스캔관리'><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_EXP_DT")))%></a>
					<br><font color='#CCCCCC'><%=AddUtil.ChangeDate2(String.valueOf(ins.get("CLS_DT")))%></font>
					<br><font color='#999999'><%=AddUtil.ChangeDate2(String.valueOf(ins.get("MIGR_DT")))%></font></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='5%' align='center'><a href="javascript:parent.insReg('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>', '<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_gs.gif align=absmiddle border=0></a></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> width='5%' align='center'><a href="javascript:parent.insCls('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>', '<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_hj.gif align=absmiddle border=0></a></td>						
                </tr>
              <%		}%>
            </table>
	    </td>
	<!--
	<td class='line' width='60'>
	    <table border="0" cellspacing="1" cellpadding="0" width='60'>
          <%//for (int i = 0 ; i < ins_size ; i++){
				//Hashtable ins = (Hashtable)inss.elementAt(i);%>
          <tr> 
            <td <%//if(ins.get("USE_YN").equals("N")){%>class='is'<%//}%> width='30' align='center'><a href="javascript:parent.insReg('<%//=ins.get("RENT_MNG_ID")%>', '<%//=ins.get("RENT_L_CD")%>', '<%//=ins.get("CAR_MNG_ID")%>', '<%//=ins.get("INS_ST")%>')" onMouseOver="window.status=''; return true">갱신</a></td>
            <td <%//if(ins.get("USE_YN").equals("N")){%>class='is'<%//}%> width='30' align='center'><a href="javascript:parent.insCls('<%//=ins.get("RENT_MNG_ID")%>', '<%//=ins.get("RENT_L_CD")%>', '<%//=ins.get("CAR_MNG_ID")%>', '<%//=ins.get("INS_ST")%>')" onMouseOver="window.status=''; return true">해지</a></td>						
          </tr>
          <%//}%>
        </table>
	</td>-->
    </tr>
<%	}else{%>                     
    <tr>
	    <td class='line' width='100%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
    		        <td align='center'>등록된 데이타가 없습니다</td>
    		    </tr>
    	    </table>
	    </td>
	<!--
	<td class='line' width='60'>
	    <table border="0" cellspacing="1" cellpadding="0" width='60'>
          <tr>
		  <td>&nbsp;</td>
		</tr>
	  </table>
	</td>-->
    </tr>
<% 	}%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=ins_size%>';
//-->
</script>
</form>
</body>
</html>
