<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, card.*, acar.res_search.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	if(gubun1.equals("") && gubun2.equals("") && gubun3.equals("") && st_dt.equals("") && end_dt.equals("")){
		gubun1 = "2";
		gubun2 = "1";
		gubun3 = "2";
		
		st_dt = AddUtil.getDate(1)+""+AddUtil.getDate(2)+"01";
		end_dt = rs_db.addMonth(st_dt, 4);
		
	}
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String s_yy 	= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");

	
	//ī������ ����Ʈ ��ȸ
	Vector card_kinds = CardDb.getCardKinds("CARD_SCD", "");
	int ck_size = card_kinds.size();	
	
	String card_kind = request.getParameter("card_kind")==null?"":request.getParameter("card_kind");
	
	//ī�彺���� ����Ʈ ��ȸ
	Vector vt = new Vector();
	int vt_size = 0;	
	
	vt = CardDb.getCardRtnStat2(st_dt, end_dt);
	vt_size = vt.size();	
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	
	int count = 0;	
%>



<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
  function cng_card_kind(value){
		var fm = document.form1;
		if(fm.s_yy.value == '2021' && toInt(fm.s_mm.value) > 0 && toInt(fm.s_mm.value) < 7){
			alert('2021��7�� ���� ����Ÿ�� �����ϴ�.'); return;
		}
		fm.action = "card_rtn_sc.jsp";
		if(fm.gubun3.value == '2'){
			fm.action = "card_rtn_sc2.jsp";
		}		
		fm.target = "_self";
		fm.submit();
  }
  
	function card_Search(){
		var fm = document.form1;
		/*
		if(fm.s_yy.value == '2021' && toInt(fm.s_mm.value) > 0 && toInt(fm.s_mm.value) < 7){
			alert('2021��7�� ���� ����Ÿ�� �����ϴ�.'); return;
		}
		fm.action="card_rtn_sc.jsp";
		if(fm.gubun3.value == '2'){
			fm.action = "card_rtn_sc2.jsp";
		}
		*/
		fm.action = "card_rtn_sc2.jsp";
		fm.target="_self";
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') card_Search();
	}	
	
	  function CardStatBase(rtn_dt){
			var fm = document.form1;
			//fm.card_kind.value = '';
			//fm.gubun1.value = '2';
			//fm.gubun2.value = '';
			//fm.gubun3.value = '1';			
			fm.st_dt.value = rtn_dt;
			fm.end_dt.value = rtn_dt;
			fm.action = "card_rtn_sc.jsp";
			fm.target="_self";
			fm.submit();
	  }	
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='cash_rtn_sc.jsp' method='post' target='t_content'>
<input type='hidden' name='rtn_dt' value=''>
<input type='hidden' name='cardno' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1050>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ī���ݻ�ȯ������</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td>&nbsp;
            <!-- 
                        ���� : 
              <select name="gubun3" id="gubun3">
                <option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>ī��纰</option>
                <option value='2' <%if(gubun3.equals("2")){%>selected<%}%>>���ں�</option>
              </select>
              &nbsp;
               ī��� : 
              <select name="card_kind" id="card_kind" onChange="javascript:cng_card_kind(this.value)" >
                <option value=''>����</option>
                <%if(ck_size > 0){
                    for (int i = 0 ; i < ck_size ; i++){
                      Hashtable ht = (Hashtable)card_kinds.elementAt(i);
                %>
                <option value='<%= ht.get("CODE") %>' <%if(card_kind.equals(String.valueOf(ht.get("CODE")))){%>selected<%}%>><%= ht.get("CARD_KIND") %></option>
                <%	}
                  }
                %>
              </select>
              &nbsp;
                        �뵵���� : 
              <select name="gubun2" id="gubun2" onChange="javascript:cng_card_kind(this.value)">
                <option value=''>����</option>
                <option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>�����ڱ�</option>
                <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>�������</option>
                <option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>����/���漼</option>
              </select>
            			      &nbsp;&nbsp;&nbsp;
            			<input type='radio' name="gubun1" value='1' <%if(gubun1.equals("1")){%>checked<%}%>>����
            			&nbsp;      
						<select name="s_yy">
			  			<%for(int i=2021; i<=AddUtil.getDate2(1)+1; i++){%>
							<option value="<%=i%>" <%if(s_yy.equals(Integer.toString(i))){%>selected<%}%>><%=i%>��</option>
						<%}%>
						</select>
	        			<select name="s_mm">
	        			<option value="" <%if(s_mm.equals("")){%>selected<%}%>>��ü</option>
	          			<%for(int i=1; i<=12; i++){%>
	          				<option value="<%=AddUtil.addZero2(i)%>" <%if(s_mm.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
	          			<%}%>
	        			</select>                
            			&nbsp;&nbsp;&nbsp; 
            			      
            			<input type='radio' name="gubun1" value='2' <%if(gubun1.equals("2")){%>checked<%}%>>
            			-->
            			
            			<input type='hidden' name='gubun1' value='2'>
            			
            			�Ⱓ &nbsp;  
            			<input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                                ~ 
                        <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">    

                        
              &nbsp;<a href="javascript:card_Search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
        <td align="right">(�ݾ״���:��, ���ϸ�������)</td>
    </tr>	
    <tr> 
        <td class=h></td>
    </tr>	
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td rowspan='3' width='4%' class='title'>����</td>
                    <td rowspan='3' class='title'>������</td>
                    <td colspan='4' class='title'>������Ȳ</td>
                    <td colspan='2' class='title'>������Ȳ</td>
                    <td rowspan='3' width='12%' class='title'>�ܾ�</td>
                </tr>
                <tr>
                    <td rowspan='2' width='12%' class='title'>�����ȯ</td>
                    <td colspan='2' width='12%' class='title'>�����ȯ</td>
                    <td rowspan='2' width='12%' class='title'>�հ�</td>
                    <td rowspan='2' width='12%' class='title'>��������</td>
                    <td rowspan='2' width='12%' class='title'>�ݾ�</td>
                    
                </tr>
                <tr>
                    <td width='12%' class='title'>��������</td>
                    <td width='12%' class='title'>�ݾ�</td>                    
                </tr>
                <%
                	if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					            
					            long a_amt = AddUtil.parseLong(String.valueOf(ht.get("A_AMT")));
					            long b_amt = AddUtil.parseLong(String.valueOf(ht.get("B_AMT")));
					            long c_amt = AddUtil.parseLong(String.valueOf(ht.get("C_AMT")));
					            long d_amt = AddUtil.parseLong(String.valueOf(ht.get("D_AMT")));
					            long e_amt = AddUtil.parseLong(String.valueOf(ht.get("E_AMT")));
					            
				      			total_amt1 = total_amt1 + a_amt;
				      			total_amt2 = total_amt2 + b_amt;
				      			total_amt3 = total_amt3 + c_amt;
				      			total_amt4 = total_amt4 + d_amt;
				      			total_amt5 = total_amt5 + e_amt;
				      							      			
				      			count++;
					      %>
                <tr>
                    <td class='title'><%=count%></td>
                    <td align='center'><a href="javascript:CardStatBase('<%=ht.get("A_DT")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("A_DT")))%></a></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(b_amt)%></td>
                    <td align='center'><font color='red'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RTN_DT")))%></font></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(c_amt)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(a_amt)%></td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("D_DT")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(d_amt)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(e_amt)%></td>
                </tr>
                <%		
                		}%>
                <tr>
                    <td class='title' colspan='2'>�հ�</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt2)%></td>
                    <td class='title'> </td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt3)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt1)%></td>
                    <td class='title'> </td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt4)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt5)%></td>
                </tr>		            
		        <%}else{%>
                <tr>
                    <td colspan="9" align="center">��ϵ� ����Ÿ�� �����ϴ�.</td>
                </tr>
		        <%}%>
            </table>
	    </td>
    </tr>   
  </table>
</form>
</body>
</html>
