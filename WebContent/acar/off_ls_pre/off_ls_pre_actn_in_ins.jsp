<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.offls_pre.*"%>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="ins" scope="page" class="acar.offls_pre.Offls_insBean"/>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	Offls_insBean[] inses = olpD.getOffls_ins(car_mng_id);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsComBean[] insCom = c_db.getInsComAll();
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	}
	
	function init(){		
		setupEvents();
	}
	
function updApprsl_ins(ioru){
	var fm = document.form1;
	var ins_st_dt = ChangeDate2(fm.ins_st_dt.value);
	var ins_ed_dt = ChangeDate2(fm.ins_ed_dt.value);
	var pay_pr_dt = ChangeDate2(fm.pay_pr_dt.value);
	if(ins_st_dt != "" && ins_ed_dt != "" && pay_pr_dt != ""){
		if(ioru=="i"){
			if(!confirm('등록 하시겠습니까?')){ return; }
		}else if(ioru=="u"){
			if(!confirm('수정 하시겠습니까?')){ return; }
		}else if(ioru=="d"){
			if(!confirm('삭제 하시겠습니까?')){ return; }
		}else if(ioru=="c"){
			if(!confirm('완료처리 하시겠습니까?')){ return; }
		}
		fm.gubun.value = ioru;
		fm.target = "i_no";
		fm.action = "/acar/off_ls_pre/off_ls_pre_updApprsl_ins.jsp";
		fm.submit();
	}else{
		if(ins_st_dt==""){ alert("보험시작일을 입력해 주세요!"); }
		if(ins_ed_dt==""){ alert("보험만료일을 입력해 주세요!"); }
		if(pay_pr_dt==""){ alert("입금일자를 입력해 주세요!"); }
		return;
	}
}
function setting(idx)
	{
		var fm = document.form1;
		fm.ins_com_id.value 	= fm.ins_com_id_s[idx].value;
		fm.ins_type.value  	= fm.ins_type_s[idx].value;
		fm.ins_st_dt.value 	= fm.ins_st_dt_s[idx].value;
		fm.ins_ed_dt.value 	= fm.ins_ed_dt_s[idx].value;
		fm.pay_pr.value 	= fm.pay_pr_s[idx].value;
		fm.pay_pr_dt.value 	= fm.pay_pr_dt_s[idx].value;
	}
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>

<body bgcolor="#FFFFFF" text="#000000" onLoad="javascript:init()">
<form name='form1' method='post' action=''>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="gubun" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
	    <td class=line2></td>
	</tr>
    <tr id='tr_title' style='position:relative;z-index:1'> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding='0' width="100%">
                <tr> 
        			<td class='title' width=5%>연번</td>
                    <td class='title' width=15%>보험회사</td>
                    <td class='title' width=10%>보험종류</td>
                    <td class='title' width=23%">보험기간</td>
                    <td class='title' width=11%>보험가격(원)</td>
                    <td class='title' width=11%>입금일자</td>
                    <td class='title' width=25%>&nbsp;</td>
                </tr>
		    </table>
	    </td>
	</tr>
	<tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding='0' width="100%" >
		  <% for(int i=0; i< inses.length; i++){ 
				ins = inses[i];%>
                <tr>
        		 	<td align="center" width=5%><a href='javascript:setting("<%= i %>");' onMouseOver="window.status=''; return true"><%= i+1 %></a></td>
                    <td align="center" width=15%>
        			<input type="hidden" name="ins_com_id_s" value='<%= ins.getIns_com_id() %>'>			
        			<input type='text' name='ins_com_nm_s' value='<%= olpD.getIns_com_nm(ins.getIns_com_id()) %>' size='12' class='white'></td>
                    <td align="center" width=10%>
        			<input type="hidden" name="ins_type_s" value='<%= ins.getIns_type() %>'>
        			<input type='text' name='ins_type_h' value='<%if(ins.getIns_type().equals("1")){ %>책임<%}else{%>종합<%}%>' size='8' class='white'></td>
                    <td align="center" width=23%><input type='text' name='ins_st_dt_s' value='<%= AddUtil.ChangeDate2(ins.getIns_st_dt()) %>' size='12' class='white'>
        			 ~ <input type='text' name='ins_ed_dt_s' value='<%= AddUtil.ChangeDate2(ins.getIns_ed_dt()) %>' size='12' class='white'></td>
                    <td align="center" width=11%><input type='text' name='pay_pr_s' value='<%= AddUtil.parseDecimal(ins.getPay_pr()) %>' size='10' class='white'></td>
                    <td align="center" width=11%><input type='text' name='pay_pr_dt_s' value='<%= AddUtil.ChangeDate2(ins.getPay_pr_dt()) %>' size='12' class='white'></td>
                    <td width=25%>&nbsp;</td>
                </tr>
		  <% } %>
                <tr> 
        		  	<td width=5%>&nbsp;</td>
                    <td align="center" width=15%><select name="ins_com_id">
                        <option value="">선택</option>
                        <%if(insCom.length > 0){
        								for (int i = 0 ; i < insCom.length ; i++){%>
                        <option value='<%=insCom[i].getIns_com_id()%>'><%=insCom[i].getIns_com_nm()%></option>
                        <%}
        							}%>
                      </select></td>
                    <td align="center" width=10%><select name="ins_type">
                        <option>선택</option>
                        <option value="1" >책임</option>
                        <option value="2" >종합</option>
                      </select></td>
                    <td align="center" width=23%><input class="text" type="text" name="ins_st_dt" size="11" value="" onBlur='javascript:this.value=ChangeDate(this.value)'>
                      ~ 
                      <input class="text" type="text" name="ins_ed_dt" size="11" value="" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td align="center" width=11%><input class="num" type="text" name="pay_pr" size="10" value="" onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원 </td>
                    <td align="center" width=11%><input class="text" type="text" name="pay_pr_dt" size="12" value="" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td align="center" width=25%> <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>
        			    <a href='javascript:updApprsl_ins("i");'><img src=../images/center/button_in_yj.gif border=0 align=absmiddle></a>&nbsp; 
        			    <a href='javascript:updApprsl_ins("u");'><img src=../images/center/button_in_modify.gif border=0 align=absmiddle></a>&nbsp;
        			    <a href='javascript:updApprsl_ins("d");'><img src=../images/center/button_in_delete.gif border=0 align=absmiddle></a>&nbsp;
        			    <a href='javascript:updApprsl_ins("c");'><img src=../images/center/button_in_end.gif border=0 align=absmiddle></a>
                    <%}%></td>
                </tr>
            </table>
        </td>
    </tr>
</table> 
</form>
</body>
</html>
