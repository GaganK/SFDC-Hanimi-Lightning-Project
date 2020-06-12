.slds-scope
{
  font-family : FuturaBT-Book, Helvetica, Arial, Sans-Serif !important;
  font-size   : 0.81rem !important;
}
.slds-form-element__label
{
  font-family : FuturaBT-Book, Helvetica, Arial, Sans-Serif !important;
  font-size   : 0.81rem !important;
}
.slds-select[size]
{
  height : 2rem !important;
}
.slds-scope .slds-tabs--path .slds-is-current
{
  background-color : #EC047B;
}
.slds-scope .slds-tabs--path .slds-is-complete
{
  background-color : #000000;
}
.slds-scope .slds-tabs--path .slds-is-complete + .slds-is-complete:before
{
  background-color : #000000;
}
.slds-scope .slds-tabs--path__item + .slds-is-current:before
{
  background-color : #000000;
}
.slds-scope .slds-tabs--path .slds-is-current + .slds-is-incomplete:before
{
  background-color : #EC047B;
}
.slds-tabs--path__link not-active
{
  background-color : #EC047B;
}
.not-active
{
  background-color : #EC047B;
  pointer-events   : none;
  cursor           : default;
}
.slds-scope .slds-button--neutral
{
  color            : #FFFFFF;
  background-color : #EC047B;
  border           : 1px solid #EC047B;
}
/*** tooltip Container
Usage:

<div class="toolTip">
  <control>
    <span class="toolTipText">Tooltip text</span>
  </control>
</div>
***/
.toolTip
{
  position      : relative;
  display       : inline-block;
  border-bottom : 0px dotted black; /* If You Want Dots Under The Hoverable Text */
}
/* toolTipText */
.toolTip .toolTipText
{
  visibility       : hidden;
  width            : 120px;
  background-color : #f5f5f5;
  color            : #000000;
  text-align       : center;
  padding          : 5px 0;
  border-radius    : 6px;
  /* Position The toolTip Text */
  position         : absolute;
  z-index          : 1;
}
/* Show The toolTip Text On Mouse Over The toolTip Container */
.toolTip:hover .toolTipText
{
  visibility : visible;
}