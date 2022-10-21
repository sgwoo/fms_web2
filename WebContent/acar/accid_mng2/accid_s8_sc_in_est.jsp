<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title ���� */
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
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"0":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"2":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	if(s_kd.equals("5")||s_kd.equals("9")||s_kd.equals("10")) t_wd = AddUtil.replace(t_wd, "-", "");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	Vector accids = new Vector();
	
	accids = as_db.getAccidS8List2(br_id, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc, s_st);
	int accid_size = accids.size();
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='accid_size' value='<%=accid_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='1860'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='540' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>					
                    <td width='60' class='title'>����</td>
                    <td width='60' class='title'>�������</td>					
                    <td width='60' class='title'>�Աݱ���</td>
                    <td width='60' class='title'><span title='(������)'>�����</span></td>
        		    <td width='100' class='title'>����ȣ</td>
        		    <td width='120' class='title'>��ȣ</td>
        		    <td width='80' class='title'>������ȣ</td>
        		</tr>
	        </table>
	    </td>
	    <td class='line' width='1320'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
        		    <td width='7%' class='title'>����</td>				
                    <td width='7%' class='title'>����Ͻ�</td>
                    <td width='5%' class='title'>�����</td>			
                    <td width='7%' class='title'>��������</td>
                    <td width='6%' class='title'>�������</td>			
                    <td width='7%' class='title'>û�����ɱݾ�</td>
                    <td width='7%' class='title'>û���ݾ�</td>
                    <td width='6%' class='title'>û������</td>
                    <td width='7%' class='title'>�Աݱݾ�</td>
                    <td width='6%' class='title'>�Ա�����</td>																				
                    <td width='23%' class='title'>Ư�̻���</td>			
                    <td width='6%' class='title'>���������</td>
                    <td width='6%' class='title'>���������</td>			
                </tr>
            </table>
	    </td>
    </tr>
<%	if(accid_size > 0){%>
    <tr>
	<td class='line' width='540' id='td_con' style='position:relative;'>			
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <% for (int i = 0 ; i < accid_size ; i++){
				Hashtable accid = (Hashtable)accids.elementAt(i);
				if(gubun3.equals("4") && AddUtil.parseInt(String.valueOf(accid.get("DLV_MON"))) > 2 ){
					continue;
				}%>
          <tr> 
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='60' align='center'><a name="<%=i+1%>"><%=i+1%> 
              <%if(accid.get("USE_YN").equals("Y")){%>
              <%}else{%>
              (�ؾ�) 
              <%}%>
              </a>
			</td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='60' align='center'> 
              <%if(String.valueOf(accid.get("SETTLE_ST_NM")).equals("����")){%>
              <font color="#FF6600">����</font>
              <%}else{%>
              ���� 
              <%}%>
            </td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='60' align='center'> 
              <%if(String.valueOf(accid.get("PAY_DT")).equals("")){%>
              <font color="#FF6600">�̼���</font>
              <%}else{%>
              ���� 
              <%}%>
            </td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='60' align='center'><%=accid.get("ACCID_ST_NM")%>(<%=accid.get("OT_FAULT_PER")%>)</td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='100' align='center'><a href="javascript:parent.AccidentDisp('<%=accid.get("RENT_MNG_ID")%>', '<%=accid.get("RENT_L_CD")%>', '<%=accid.get("CAR_MNG_ID")%>', '<%=accid.get("ACCID_ID")%>', '<%=accid.get("ACCID_ST")%>','<%=accid.get("DLV_MON")%>���̳�','<%=accid.get("CAR_AMT")%>','<%=accid.get("TOT_AMT")%>','<%=accid.get("REQ_EST_AMT")%>','<%=i%>', '<%=accid.get("AMOR_EST_ID")%>')" onMouseOver="window.status=''; return true"><%=accid.get("RENT_L_CD")%></a></td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='120' align='center'><span title='<%=accid.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=accid.get("RENT_MNG_ID")%>', '<%=accid.get("RENT_L_CD")%>', '1')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(accid.get("FIRM_NM")), 8)%></a></span></td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='center'><%=accid.get("CAR_NO")%></td>
          </tr>
          <%		}%>
          <tr> 
            <td class=title colspan="7" align='center'>&nbsp;</td>
          </tr>
        </table>
	</td>
	<td class='line' width='1320'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for (int i = 0 ; i < accid_size ; i++){
				Hashtable accid = (Hashtable)accids.elementAt(i);
				if(AddUtil.parseInt(String.valueOf(accid.get("DLV_MON"))) > 2 ){
					continue;
				}
				%>
          <tr> 
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='7%' align='center'><span title='<%=accid.get("CAR_NM")%>'><%=Util.subData(String.valueOf(accid.get("CAR_NM")), 6)%></span></td>		  
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='7%' align='center'><%=accid.get("ACCID_DT")%></td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='5%' align='center'><%=accid.get("DLV_MON")%>���̳�</td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='7%' align='right'><%=Util.parseDecimal(String.valueOf(accid.get("CAR_AMT")))%></td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='6%' align='right'><%=Util.parseDecimal(String.valueOf(accid.get("TOT_AMT")))%></td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='7%' align='right'><%=Util.parseDecimal(String.valueOf(accid.get("REQ_EST_AMT")))%></td>
			<td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='7%' align='right'><%=Util.parseDecimal(String.valueOf(accid.get("AMOR_REQ_AMT")))%></td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='6%' align='center'><%=accid.get("AMOR_REQ_DT")%></td>			
			<td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='7%' align='right'><%=Util.parseDecimal(String.valueOf(accid.get("AMOR_PAY_AMT")))%></td>			
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='6%' align='center'><%=accid.get("AMOR_PAY_DT")%></td>			
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='23%' align='center'><span title='<%=accid.get("SUB_ETC")%>'><%=Util.subData(String.valueOf(accid.get("SUB_ETC")), 25)%></span></td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='6%' align='center'><%=accid.get("REG_NM")%></td>
            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='6%' align='center'><%=accid.get("MNG_NM")%></td>			
          </tr>
          <%		total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(accid.get("REQ_EST_AMT")));
		 			total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(accid.get("AMOR_REQ_AMT")));
					total_amt3 = total_amt3 + AddUtil.parseLong(String.valueOf(accid.get("AMOR_PAY_AMT")));
		  			}%>
          <tr> 
            <td class=title align='center'>��</td>		  
            <td class=title align='center'>&nbsp;</td>
            <td class=title align='center'>&nbsp;</td>			
            <td class=title align='center'>&nbsp;</td>			
            <td class=title align='center'>&nbsp;</td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>			
            <td class=title style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>			
            <td class=title align='center'>&nbsp;</td>			
            <td class=title style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>			
            <td class=title align='center'>&nbsp;</td>
            <td class=title align='center'>&nbsp;</td>			
            <td class=title align='center'>&nbsp;</td>			
            <td class=title align='center'>&nbsp;</td>						
          </tr>
        </table>
	</td>
  </tr>
<%	}else{%>                     
  <tr>
	<td class='line' width='540' id='td_con' style='position:relative;'>			
      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
		  <td align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
		</tr>
	  </table>
	</td>
	<td class='line' width='1320'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		  <td>&nbsp;</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>
    <tr>
        <td colspan=2>�� ���1������ = ������� * 15% * �����Ǻ��� / ���2������ = ������� * 10% * �����Ǻ��� </td>
    </tr>
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
//-->
</script>
</form>
</body>
</html>
