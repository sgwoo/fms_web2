<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.common.*, acar.util.*, acar.watch.*, acar.estimate_mng.*, acar.user_mng.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	WatchDatabase wc_db = WatchDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String s_dd 	= AddUtil.getDate(3);
	
	if(s_yy.equals("")){
		s_yy = AddUtil.getDate(1);
		s_mm = AddUtil.getDate(2);
		
		//���������
		String base_dt = af_db.getValidDt(s_yy+""+s_mm+"25");
		
		//out.println(base_dt);
		
		// ���� 8,10 ���� 6,8�� ���� af_db.getValidDt()�� yyyyMMdd�������� ����
		if(AddUtil.parseInt(s_dd) > AddUtil.parseInt(base_dt.substring(6,8))){
			String next_dt = c_db.addMonth(AddUtil.getDate(4), 1);
			
			//out.println(next_dt);
			
			//�Ϳ�
			s_yy = next_dt.substring(0,4);
			s_mm = next_dt.substring(5,7);
		}
		
	}
	
	//ARS call ��Ȳ
	Vector vt = wc_db.ArsCallStatBase(s_yy, s_mm, sort);
	int vt_size = vt.size();
	
	String var1 = e_db.getEstiSikVarCase("1", "", "ars_call_base_amt");//�����������ޱ��ؾ�
	String var2 = e_db.getEstiSikVarCase("1", "", "ars_call_base_dt1");//�����������ޱⰣ
	String var3 = e_db.getEstiSikVarCase("1", "", "ars_call_base_dt2");//�����������ޱⰣ
	String var4 = wc_db.ArsCallStatBaseDay();
	
	//��ȭ�� �ѰǼ�
	long total_cnt = 0;
	for (int i = 0 ; i < vt_size ; i++){
        Hashtable ht = (Hashtable)vt.elementAt(i);
        total_cnt = total_cnt + AddUtil.parseLong(String.valueOf(ht.get("CALL_COUNT")));
	}
	
	//�ٹ��Ⱓ������ �ѰǼ�
	long total_cnt2 = 0;
	for (int i = 0 ; i < vt_size ; i++){
        Hashtable ht = (Hashtable)vt.elementAt(i);
        total_cnt2 = total_cnt2 + AddUtil.parseLong(String.valueOf(ht.get("SECTION")));
	}
	
	long base_call_amt = 0;
	long base_call_amt2 = 0;
	
	//��ȭ�� �ܰ�
	if(total_cnt > 0 ){
		base_call_amt =AddUtil.parseLong(var1)/2/total_cnt;
		base_call_amt = (long)AddUtil.parseDouble(AddUtil.calcMath("CEIL",String.valueOf(base_call_amt),-1)); //����������
	}
	
	//���� �ܰ�
	if(total_cnt2 > 0 ){
		base_call_amt2 =AddUtil.parseLong(var1)/2/total_cnt2;
		base_call_amt2 = (long)AddUtil.parseDouble(AddUtil.calcMath("CEIL",String.valueOf(base_call_amt2),-1)); //����������
	}
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	
	
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function Search(){
	var fm = document.form1;
	fm.action="ars_call_stat_base_sc.jsp";
	fm.target="_self";
	fm.submit();
}
//�˾�
function display_pop(st, user_id){
	var taxInvoice = window.open("about:blank", "Stat", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=850px, height=800px");
	if(st==1){
		//���������ϻ���
		document.form1.action="ars_call_stat_base_excel_pl.jsp";
		document.form1.target="i_no";
	}else{
		//���θ���Ʈ 
		document.form1.call_user_id.value = user_id;
		document.form1.action="ars_call_stat_base_list.jsp";
		document.form1.target="Stat";		
	}
	document.form1.submit();
}	  
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='ars_call_stat_base_sc.jsp' method='post' target='t_content'>
<input type='hidden' name='var1' value='<%=var1%>'>
<input type='hidden' name='var2' value='<%=var2%>'>
<input type='hidden' name='var3' value='<%=var3%>'>
<input type='hidden' name='base_call_amt' value='<%=base_call_amt%>'>
<input type='hidden' name='base_call_amt2' value='<%=base_call_amt2%>'>
<input type='hidden' name='call_user_id' value=''>

  <table border="0" cellspacing="0" cellpadding="0" width=900>
    <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�ѹ�����",user_id)){%>
    <tr>
	    <td align="right"><input type="button" class="button" value="���������ϻ���" onclick="javascript:display_pop(1,'');"></td>
	  </tr>
	<%}%>  
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����� �������� ��Ȳ </span></td>
	  </tr>
    <tr>
        <td>&nbsp;
     ���޿� : <select name="s_yy">
			  			<%for(int i=2020; i<=AddUtil.getDate2(1)+1; i++){%>
							<option value="<%=i%>" <%if(s_yy.equals(Integer.toString(i))){%>selected<%}%>><%=i%>��</option>
						<%}%>
						</select>						
			      &nbsp;
			      <select name="s_mm">
			  			<%for(int i=1; i<=12; i++){%>
							<option value="<%=AddUtil.addZero2(i)%>" <%if(s_mm.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=i%>��</option>
						<%}%>
						</select>           
        ���� : <select name="sort">
                <option value='1' <%if(sort.equals("1")){%>selected<%}%>>���</option>
                <option value='2' <%if(sort.equals("2")){%>selected<%}%>>����</option>
                <option value='3' <%if(sort.equals("3")){%>selected<%}%>>��ȭ��</option>
                <option value='4' <%if(sort.equals("4")){%>selected<%}%>>����</option>
              </select>
            			  &nbsp;<a href="javascript:Search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>   
              &nbsp;&nbsp;&nbsp;(����25��~���24��)</td>
    </tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td rowspan='2' width='5%' class='title'>����</td>
                    <td rowspan='2' width='10%' class='title'>���</td>
                    <td rowspan='2' width='15%' class='title'>����</td>                    
                    <td colspan='2' class='title'>�ٹ��Ⱓ��</td>
                    <td colspan='3' class='title'>��ȭ��</td>
                    <td rowspan='2' width='15%' class='title'>��������</td>
                </tr>
                <tr>
                    <td width='5%' class='title'>����</td>
                    <td width='15%' class='title'>����</td>
                    <td width='5%' class='title'>�Ǽ�</td>
                    <td width='15%' class='title'>�ð�</td>
                    <td width='15%' class='title'>�ݾ�</td>
                </tr>                
                <%	long call_amt = 0; 
                	long call_amt2 = 0;
                	
                	if(vt_size > 0){
		            	for (int i = 0 ; i < vt_size ; i++){
				            Hashtable ht = (Hashtable)vt.elementAt(i);
				            int v_h = AddUtil.parseInt(String.valueOf(ht.get("TH")));
				            int v_m = AddUtil.parseInt(String.valueOf(ht.get("TM")));
				            int v_s = AddUtil.parseInt(String.valueOf(ht.get("TS")));
				            int v_time = AddUtil.parseInt(String.valueOf(ht.get("CALL_TIME")));
				            v_h = 0;
				            v_m = 0;
				            v_s = 0;
				            
			    	        //���� �� ó��
			        	    if(v_time > 60){
			            		int add_m = v_time/60;
				            	v_m = v_m + add_m;
				            	v_s = v_time - (add_m*60);
				            }else{
				            	v_s = v_time;
				            }
				            //���� �� ó��
			    	        if(v_m > 60){
			        	    	int add_h = v_m/60;
			            		v_h = v_h + add_h;
				            	v_m = v_m - (add_h*60);
				            }
			            	
			    	        call_amt = AddUtil.parseLong(String.valueOf(ht.get("CALL_COUNT")))*base_call_amt;
			    	        call_amt2 = AddUtil.parseLong(String.valueOf(ht.get("SECTION")))*base_call_amt2;
			    	        
				            total_amt1 = total_amt1 + call_amt;
				            total_amt2 = total_amt2 + call_amt2;
				%>
                <tr>
                    <td align=center><%=i+1%></td>
                    <td align=center><%=ht.get("ID")%></td>
                    <td align=center><a href="javascript:display_pop(2, '<%=ht.get("USER_ID")%>')"><%=ht.get("USER_NM")%></a></td>
                    <td align="right"><%=ht.get("SECTION")%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(call_amt2) %></td>
                    <td align="right"><%=ht.get("CALL_COUNT")%></td>
                    <td align="right"><%=AddUtil.addZero2(v_h)%>��<%=AddUtil.addZero2(v_m)%>��<%=AddUtil.addZero2(v_s)%>��</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(call_amt) %></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(call_amt+call_amt2) %></td>
                </tr>                   
		            <%	}%>
                <tr>
                    <td colspan="3" class='title'>�հ�(�� ����)</td>
                    <td align="right"><%=total_cnt2%></td>
                    <td align="right"><%=AddUtil.parseDecimal(total_amt2)%></td>
                    <td align="right"><%=total_cnt%></td>
                    <td align="right"></td>
                    <td align="right"><%=AddUtil.parseDecimal(total_amt1)%></td>
                    <td align="right"><%=AddUtil.parseDecimal(total_amt1+total_amt2)%></td>
                </tr>		            
		            <%}else{%>
                <tr>
                    <td colspan="9" align="center">��ϵ� ����Ÿ�� �����ϴ�.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>  	
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������� ���ޱ��� </span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td colspan='2' class='title'>����</td>
                    <td width='20%' class='title'>�ݾ�</td>
                    <td width='50%' class='title'>����</td>
                </tr>    
                <tr>
                    <td colspan='2' align=center>�����������ޱ��ؾ�(�ѷ���)</td>
                    <td align=right><%=AddUtil.parseDecimalLong(var1)%></td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(var2)%> ����</td>
                </tr>
                <tr>
                    <td colspan='2' align=center>��ȭ�Ǵ� �ܰ�</td>
                    <td align=right><%=AddUtil.parseDecimalLong(base_call_amt)%></td>
                    <td>&nbsp;=���ޱ��ؾ�(�ѷ���)/2/��ȭ�� �հ�</td>
                </tr>                
                <tr>
                    <td width='15%' rowspan='3' align=center>�ٹ��Ⱓ�� ����</td>
                    <td width='15%' align=center>1����</td>
                    <td align=center>5�� �̸�</td>
                    <td> </td>
                </tr>
                <tr>
                    <td align=center>2����</td>
                    <td align=center>5�� �̻� ~ 10�� �̸�</td>
                    <td> </td>
                </tr>
                <tr>
                    <td align=center>3����</td>
                    <td align=center>10�� �̻�</td>
                    <td> </td>
                </tr>                
            </table>
	    </td>
    </tr>  
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
