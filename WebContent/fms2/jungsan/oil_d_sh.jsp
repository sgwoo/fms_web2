<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, card.*, acar.util.*,  acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");

	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String sort		= request.getParameter("sort")==null?"":request.getParameter("sort");
			
	//chrome ���� 
	String height = request.getParameter("height")==null?"":request.getParameter("height");		
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
		
//	int cnt = 2; //��Ȳ ��� �Ѽ�
//	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height) - 100;//��Ȳ ���μ���ŭ ���� ���������� ������
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
<script language="JavaScript">

var delay = 2000;
var submitted = false;

(function() {

  // doubleFlag�� ó���� false�� �ʱ�ȭ �Ѵ�.
  var doubleFlag = false;
  
  // ���� Ŭ�� �Լ� ����
  this.doubleCheck = function doubleCheck() {
    if(doubleFlag == true) {
      return doubleFlag;
    } else {
      doubleFlag = true;
      return false;
    }
  }

  // ���� Ŭ���� �̺�Ʈ�� �߻����� �ٽ� ��ư�� �ʱ�ȭ �ϱ� ���� ���ȴ�.
  this.clickInitial = function clickInitial() {
    doubleFlag = false;
  }
})();

// Ŭ�� �̺�Ʈ
function clickSubmit() {
	var fm = document.form1;
	
	if(fm.dt[2].checked == false)
	{ 
		alert('��ȸ�Ⱓ��  �����ϼ���.');
		return;
	}
	
	if ( fm.ref_dt1.value == ""  )
	{ 
		alert('��ȸ�Ⱓ��  �Է��ϼ���.');
		return;
	}	
	if ( fm.ref_dt2.value == "" )
	{ 
		alert('��ȸ�Ⱓ��  �Է��ϼ���.');
		return;
	}
	
  // ���� Ŭ���� ���
   if(doubleCheck() == true) {

	alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');
    // �ٽ� ���������� Ŭ���̺�Ʈ�� �߻� �� �� �ֵ��� �ʱ�ȭ ��û
    clickInitial();
    return;
   }
  // �ѹ��� Ŭ���� ���
  else {
    makeCarOil();
  }
}

function makeCarOil()
{
	var fm = document.form1;
	
	fm.action="oil_d_make.jsp?make=Y";		
	fm.target="i_no";		
	fm.submit();
		
}


function Search()
{
	var fm = document.form1;
	
	if(fm.dt[0].checked == false && fm.dt[1].checked == false && fm.dt[2].checked == false)
	{ alert('��ȸ�׸���  �����Ͻʽÿ�.'); return;}
	
	fm.action="oil_d_sc.jsp";		
	fm.target="cd_foot";		
	fm.submit();
		
}

function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') Search();
}

function ChangeDT(arg)
{
	var theForm = document.form1;
	if(arg=="ref_dt1")
	{
	theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2"){
	theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}

}


function submitCheck() {

	 var fm = document.form1;
	
	 if(fm.dt[0].checked == false && fm.dt[1].checked == false && fm.dt[2].checked == false)
	 { alert('��ȸ�׸���  �����Ͻʽÿ�.'); return;}
	
	 if(fm.dt[2].checked == true ) {
		 if ( fm.ref_dt1.value == ""  )
		{ 	alert('��ȸ�Ⱓ��  �Է��ϼ���.');return;		}	
			if ( fm.ref_dt2.value == "" )
		{ 	alert('��ȸ�Ⱓ��  �Է��ϼ���.');	return;		}
      }	
	
	  if(submitted == true) { return; }

	  document.form1.srch.value = '�˻���';
	  document.form1.srch.disabled = true;
	  
	  setTimeout ('Search()', delay);
	  
	  submitted = true;
	}

	function submitInit() {

		  document.form1.srch.value = '�˻�';
		  document.form1.srch.disabled = false;
		   
		  submitted = false;
		}

	
</script>

</head>
<body>
<form  name="form1" method="POST">
 
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    

  <input type='hidden' name="height" value="<%=height%>">  

  
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=5>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>��Ȳ �� ��� > �繫ȸ�� > <span class=style5>���������� ����� �����Ȳ</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>
     <tr> 
      <td> 
        <table width="100%" border="0" cellpadding="0" cellspacing="1">
          <tr> 
          	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_ggjh.gif" >&nbsp;
			 
              <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
              �ֱ� 5�� 
                 <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
              �ֱ� 1�� 
              <input type="radio" name="dt" value="4" <%if(dt.equals("4"))%>checked<%%>>
              ��ȸ�Ⱓ
			  &nbsp;&nbsp;
				<input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
              ~ 
              <input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()"> 
		  
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jr.gif  align=absmiddle>
              <input type="radio" name="sort" value="" <%if(sort.equals(""))%>checked<%%>>
              ��ü 
              <input type="radio" name="sort" value="1" <%if(sort.equals("1"))%>checked<%%>>
      LPG      
              <input type="radio" name="sort" value="2" <%if(sort.equals("2"))%>checked<%%>>
              �������ֹ���
              <input type="radio" name="sort" value="3" <%if(sort.equals("3"))%>checked<%%>>
              ���⡤����        
			  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <!-- <a id="submitLink" href="javascript:Search()"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a>   -->
		 <input type="button" onClick="Search();" value="�˻�"/>&nbsp;&nbsp;&nbsp;&nbsp;  
		    	    
		<!-- 	 
		 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" name="srch" value="�˻�" onclick="submitCheck();">  		 
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <input type="button" name="init" value="��ư�ʱ�ȭ" onclick="submitInit();">  -->
         <% if (nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������������",user_id) ) { %>           
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <input type="button" onClick="clickSubmit();" value="����Ÿ����"/>
            <% } %>
        
			  </td>
             </tr>  
        </table>
      </td>
   
    </tr>
  </form>
  <iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</table>
</body>