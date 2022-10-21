<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.common.*, acar.util.*, acar.watch.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	WatchDatabase wc_db = WatchDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(gubun1.equals("")){
		gubun1 = "1";
	}

	//ARS ���ν��� - ��ó��
	String  d_flag1 =  wc_db.call_sp_ars_call_stat();
	
	//ARS call ��Ȳ
	Vector vt = wc_db.ArsCallStatSDay(gubun1, gubun2, gubun3, st_dt, end_dt);
	int vt_size = vt.size();
	
	//�����Ҹ���Ʈ
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();
	
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function Search(){
	var fm = document.form1;
	fm.action="ars_call_stat_sday_sc.jsp";
	fm.target="_self";
	fm.submit();
}
function display_pop(id){
	var taxInvoice = window.open("about:blank", "Stat", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=850px, height=250px");
	document.form1.id.value = id;
	document.form1.action="ars_call_stat_sday_list.jsp";
	document.form1.target="Stat";		
	document.form1.submit();
}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='ars_call_stat_sday_sc.jsp' method='post' target='t_content'>
<input type='hidden' name='call_user_id' value=''>
<input type='hidden' name='id' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1730>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ARS������Ȳ </span></td>
	  </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=1>
                <tr> 
                    <td>&nbsp;
                        <select name='gubun1'>
              <option value="1" <%if(gubun1.equals("1"))%>selected<%%>>����</option>
              <option value="2" <%if(gubun1.equals("2"))%>selected<%%>>����</option>
              <option value="3" <%if(gubun1.equals("3"))%>selected<%%>>������</option>
              <option value="7" <%if(gubun1.equals("7"))%>selected<%%>>�ײ�����</option>
              <option value="4" <%if(gubun1.equals("4"))%>selected<%%>>���</option>
              <option value="5" <%if(gubun1.equals("5"))%>selected<%%>>����</option>
              <option value="6" <%if(gubun1.equals("6"))%>selected<%%>>�Ⱓ</option>
            </select>
			      &nbsp;
            <input type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text" onBlur='javascript:this.value=ChangeDate(this.value);'>
			      ~
			      <input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text" onBlur='javascript:this.value=ChangeDate(this.value);'>
			      	&nbsp;&nbsp;&nbsp;
			      	���� : 
			      	<select name='gubun2'>
              <option value=""  <%if(gubun2.equals(""))%>selected<%%>>��ü</option>
              <option value="6" <%if(gubun2.equals("6"))%>selected<%%>>���</option>
              <option value="7" <%if(gubun2.equals("7"))%>selected<%%>>����⵿</option>
              <option value="8" <%if(gubun2.equals("8"))%>selected<%%>>����</option>
              <option value="9" <%if(gubun2.equals("9"))%>selected<%%>>��Ÿ</option>              
              <option value="10" <%if(gubun2.equals("10"))%>selected<%%>>�˼�����</option>              
              <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>��ȭ</option>
              <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>�ȳ���</option>
              <option value="3" <%if(gubun2.equals("3"))%>selected<%%>>����û</option>
              <option value="4" <%if(gubun2.equals("4"))%>selected<%%>>�������</option>              
              <option value="11" <%if(gubun2.equals("11"))%>selected<%%>>�������</option>
              <option value="12" <%if(gubun2.equals("12"))%>selected<%%>>��������</option>
            </select>					
            &nbsp;&nbsp;&nbsp;
            ���� :
            <select name='gubun3'>
              <option value=''>��ü</option>
              <%if(brch_size > 0)	{
        					for (int i = 0 ; i < brch_size ; i++){
        						Hashtable branch = (Hashtable)branches.elementAt(i);
        						if(String.valueOf(branch.get("BR_NM")).equals("��õ������")||String.valueOf(branch.get("BR_NM")).equals("���ֿ�����")||String.valueOf(branch.get("BR_NM")).equals("���ؿ�����")||String.valueOf(branch.get("BR_NM")).equals("�������")){
        							continue;
        						}
        						%>
              <option value='<%=branch.get("BR_ID")%>' <%if(gubun3.equals(String.valueOf(branch.get("BR_ID")))){%> selected <%}%>><%= branch.get("BR_NM")%></option>
              <%		}
        				}
        			%>
            </select>
            			  &nbsp;<a href="javascript:Search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
					</td>
                </tr>
            </table>
        </td>
    </tr>	 	     
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td rowspan='2' width='50' class='title'>����</td>
                    <td colspan='4' class='title'>�߽���</td>
                    <td rowspan='2' width='100' class='title'>��������</td>
                    <td colspan='4' class='title'>�����ȣ</td>
                    <td colspan='4' class='title'>������Ȳ</td>
                    <td colspan='5' class='title'>��������</td>
                    <td colspan='2' class='title'>��������</td>                    
                </tr>
                <tr>
                    <td width='100' class='title'>��ȭ��ȣ</td>
                    <td width='200' class='title'>�ŷ�ó��</td>
                    <td width='100' class='title'>������ȣ</td>
                    <td width='150' class='title'>�����Ͻ�</td>
                    <td width='50' class='title'>����</td>
                    <td width='100' class='title'>����</td>
                    <td width='50' class='title'>�����</td>
                    <td width='100' class='title'>��ȭ��ȣ</td>
                    <td width='70' class='title'>��ȭ</td>
                    <td width='70' class='title'>�ȳ���</td>
                    <td width='70' class='title'>����û</td>
                    <td width='70' class='title'>�������</td>
                    <td width='70' class='title'>���</td>
                    <td width='70' class='title'>����⵿</td>
                    <td width='70' class='title'>����</td>
                    <td width='70' class='title'>��Ÿ</td>
                    <td width='70' class='title'>�˼�����</td>
                    <td width='50' class='title'>���</td>
                    <td width='50' class='title'>����</td>
                </tr>                
                <%	if(vt_size > 0){
		            	for (int i = 0 ; i < vt_size ; i++){
				            Hashtable ht = (Hashtable)vt.elementAt(i);				            
				%>
                <tr>
                    <td align=center><%=i+1%></td>
                    <td align=center><%=ht.get("CID")%></td>
                    <td align=center><%=ht.get("FIRM_NM")%></td>
                    <td align=center><%=ht.get("CAR_NO")%></td>
                    <td align=center><%=ht.get("HANGUP_TIME")%></td>
                    <td align=center><%=ht.get("ACCESS_NM")%><%if(String.valueOf(ht.get("ACCESS_NM")).equals("")){%><%=ht.get("ACCESS_NUMBER")%><%}%></td>
                    <td align=center>
                      <%if(String.valueOf(ht.get("USER_TYPE")).equals("2")||String.valueOf(ht.get("USER_TYPE")).equals("3")){%>
                    	  <a href="javascript:display_pop('<%=ht.get("ID")%>')"><%if(String.valueOf(ht.get("USER_TYPE")).equals("2")){%>��1<%}else if(String.valueOf(ht.get("USER_TYPE")).equals("3")){%>��2<%}%></a>
                      <%} %>                      
                      <%if(String.valueOf(ht.get("USER_TYPE")).equals("1")){%>��<%}%>                      
                    </td>
                    <td align=center><%=ht.get("BR_NM")%></td>
                    <td align=center><%=ht.get("USER_NM")%></td>
                    <td align=center><%=ht.get("REDIRECT_NUMBER")%></td>
                    <td align=center><%=ht.get("STAT1")%></td>
                    <td align=center><%=ht.get("STAT2")%>
                      <%if(!String.valueOf(ht.get("STAT1")).equals("")&&String.valueOf(ht.get("STAT2")).equals("")&&(String.valueOf(ht.get("STAT6")).equals("O")||String.valueOf(ht.get("STAT7")).equals("O")||String.valueOf(ht.get("STAT8")).equals("O"))){%><%=ht.get("TIME")%><%}%>     
                    </td>
                    <td align=center><%=ht.get("STAT3")%></td>
                    <td align=center><%=ht.get("STAT4")%></td>
                    <td align=center><%=ht.get("STAT6")%></td>
                    <td align=center><%=ht.get("STAT7")%></td>
                    <td align=center><%=ht.get("STAT8")%></td>
                    <td align=center><%=ht.get("STAT9")%></td>
                    <td align=center><%=ht.get("STAT10")%></td>                    
                    <td align=center><%=ht.get("STAT11")%></td>
                    <td align=center><%if(!String.valueOf(ht.get("STAT11")).equals("O")){%>O<%}%></td>
                </tr>                   
		            <%	}%>                		            
		            <%}else{%>
                <tr>
                    <td colspan="21" align="center">��ϵ� ����Ÿ�� �����ϴ�.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr>    
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
